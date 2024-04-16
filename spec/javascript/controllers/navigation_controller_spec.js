import { Application } from '@hotwired/stimulus';
import NavigationController from 'navigation_controller.js';

describe('NavigationController', () => {
  describe('opening and closing the nav menu', () => {
    document.body.innerHTML = `
    <header class="limit-content-width" data-controller="navigation" role="banner" data-module="govuk-header">
      <div class="menu-button" id="mobile-navigation-menu-button">
        <button class="menu-button__button" id="menu-toggle" aria-expanded="false" aria-controls="primary-navigation" data-action="click->navigation#toggleNav" data-navigation-target="menu">
          <span class="menu-button__text">Menu</span>
          <span class="menu-button__icon"></span>
        </button>
      </div>
      <nav id="primary-navigation" class="hidden-mobile" data-navigation-target="nav" data-action="click->navigation#toggleNavMenuItem" aria-label="Primary navigation" role="navigation">
        <ol class="primary" data-navigation-target="primary" data-selectors="ol.category-links-list, ol.page-links-list">
          <li data-id="menu-is-teaching-right-for-me" data-direct-link="false">
            <a class="link--black link--no-underline" href="/is-teaching-right-for-me">Is teaching right for me?</a>
            <span class="nav-icon nav-icon__arrow-down" aria-hidden="true"></span>
          </li>
          <li data-id="menu-steps-to-become-a-teacher" data-direct-link="true">
            <a class="link--black link--no-underline" href="/steps-to-become-a-teacher">How to become a teacher</a>
          </li>
          <li class="active" data-id="menu-train-to-be-a-teacher" data-direct-link="false">
            <div>Train to be a teacher</div>
            <span class="nav-icon nav-icon__arrow-down" aria-hidden="true"></span>
          </li>
        </ol>
      </nav>
      <div class="dropdown-menu-container" data-navigation-target="dropdown">
        <div class="category-links">
          <ol class="category-links-list hidden-menu" id="menu-is-teaching-right-for-me" data-action="click->navigation#toggleCategoryMenuItem" data-selectors="ol.page-links-list">
            <li data-id="menu-pay-and-benefits">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me#pay-and-benefits" data-turbolinks="false">Pay and benefits</a>
              <span class="nav-icon nav-icon__arrow-right" aria-hidden="true"></span>
            </li>
            <li data-id="menu-qualifications-and-experience">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me#qualifications-and-experience" data-turbolinks="false">Qualifications and experience</a>
              <span class="nav-icon nav-icon__arrow-right" aria-hidden="true"></span>
            </li>
            <li data-id="menu-who-to-teach">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me#who-to-teach" data-turbolinks="false">Who to teach</a>
              <span class="nav-icon nav-icon__arrow-right" aria-hidden="true"></span>
            </li>
            <li data-id="menu-what-to-teach">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me#what-to-teach" data-turbolinks="false">What to teach</a>
              <span class="nav-icon nav-icon__arrow-right" aria-hidden="true"></span>
            </li>
            <li data-id="menu-school-experience">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me#school-experience" data-turbolinks="false">School experience</a>
              <span class="nav-icon nav-icon__arrow-right" aria-hidden="true"></span>
            </li>
            <li data-id="menu-view-all-is-teaching-right-for-me" data-direct-link="true">
              <a class="link--black" href="/is-teaching-right-for-me">View all in Is teaching right for me?</a>
            </li>
          </ol>
          <ol class="category-links-list hidden-menu" id="menu-train-to-be-a-teacher" data-action="click->navigation#toggleMenu" data-selectors="ol.page-links-list">
            <li data-id="menu-postgraduate-teacher-training">
              <a class="link--black link--no-underline" href="/train-to-be-a-teacher#postgraduate-teacher-training" data-turbolinks="false">Postgraduate teacher training</a>
              <span class="nav-icon nav-icon__arrow-right" aria-hidden="true"></span>
            </li>
            <li data-id="menu-qualifications-you-can-get">
              <a class="link--black link--no-underline" href="/train-to-be-a-teacher#qualifications-you-can-get" data-turbolinks="false">Qualifications you can get</a>
              <span class="nav-icon nav-icon__arrow-right" aria-hidden="true"></span>
            </li>
            <li class="active" data-id="menu-view-all-train-to-be-a-teacher" data-direct-link="true">
              <div>View all in Train to be a teacher</div>
            </li>
          </ol>
        </div>
        <div class="page-links">
          <ol class="page-links-list hidden-menu" id="menu-pay-and-benefits">
            <li data-id="menu-is-teaching-right-for-me-teacher-pay-and-benefits" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/teacher-pay-and-benefits">How much do teachers get paid?</a>
            </li>
            <li data-id="menu-is-teaching-right-for-me-career-progression" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/career-progression">How can I move up the career ladder in teaching?</a>
            </li>
            <li data-id="menu-is-teaching-right-for-me-what-pension-does-a-teacher-get" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/what-pension-does-a-teacher-get">What pension does a teacher get?</a>
            </li>
          </ol>
          <ol class="page-links-list hidden-menu" id="menu-qualifications-and-experience">
            <li data-id="menu-is-teaching-right-for-me-qualifications-you-need-to-teach" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/qualifications-you-need-to-teach">What qualifications do I need to be a teacher?</a>
            </li>
            <li data-id="menu-is-teaching-right-for-me-if-you-want-to-change-career" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/if-you-want-to-change-career">How do I change to a career in teaching?</a>
            </li>
          </ol>
          <ol class="page-links-list hidden-menu" id="menu-who-to-teach">
            <li data-id="menu-is-teaching-right-for-me-who-do-you-want-to-teach" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/who-do-you-want-to-teach">Which age group should I teach?</a>
            </li>
            <li data-id="menu-is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/teach-disabled-pupils-and-pupils-with-special-educational-needs">How can I teach children with special educational needs?</a>
            </li>
          </ol>
          <ol class="page-links-list hidden-menu" id="menu-what-to-teach">
            <li data-id="menu-is-teaching-right-for-me-computing" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/computing">Computing</a>
            </li>
            <li data-id="menu-is-teaching-right-for-me-maths" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/maths">Maths</a>
            </li>
            <li data-id="menu-is-teaching-right-for-me-physics" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/physics">Physics</a>
            </li>
          </ol>
          <ol class="page-links-list hidden-menu" id="menu-school-experience">
            <li data-id="menu-is-teaching-right-for-me-get-school-experience" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/get-school-experience">How do I get experience in a school?</a>
            </li>
            <li data-id="menu-is-teaching-right-for-me-teaching-internship-providers" data-direct-link="true">
              <a class="link--black link--no-underline" href="/is-teaching-right-for-me/teaching-internship-providers">Can I do a teaching internship?</a>
            </li>
          </ol>
          <ol class="page-links-list hidden-menu" id="menu-postgraduate-teacher-training">
            <li data-id="menu-train-to-be-a-teacher-how-to-choose-your-teacher-training-course" data-direct-link="true">
              <a class="link--black link--no-underline" href="/train-to-be-a-teacher/how-to-choose-your-teacher-training-course">How to choose your course</a>
            </li>
            <li data-id="menu-train-to-be-a-teacher-initial-teacher-training" data-direct-link="true">
              <a class="link--black link--no-underline" href="/train-to-be-a-teacher/initial-teacher-training">What to expect in teacher training</a>
            </li>
          </ol>
          <ol class="page-links-list hidden-menu" id="menu-qualifications-you-can-get">
            <li data-id="menu-train-to-be-a-teacher-what-is-qts" data-direct-link="true">
              <a class="link--black link--no-underline" href="/train-to-be-a-teacher/what-is-qts">Qualified teacher status (QTS)</a>
            </li>
            <li data-id="menu-train-to-be-a-teacher-what-is-a-pgce" data-direct-link="true">
              <a class="link--black link--no-underline" href="/train-to-be-a-teacher/what-is-a-pgce">Postgraduate certificate in education (PGCE)</a>
            </li>
          </ol>
        </div>
        <div class="key-links"></div>
      </div>
    </header>`;

    const application = Application.start();
    application.register('navigation', NavigationController);

    it('toggles the visibility of the navigation area when menu button clicked', () => {
      expect(document.querySelector('nav').classList).toContain(
        'hidden-mobile'
      );

      document.querySelector('button').click();

      expect(document.querySelector('nav').classList).not.toContain(
        'hidden-mobile'
      );

      document.querySelector('button').click();

      expect(document.querySelector('nav').classList).toContain(
        'hidden-mobile'
      );
    });

    it('toggles the dropdown menu when a menu item is clicked', () => {
      const menu = document.querySelector('ol.primary > li[data-id=menu-is-teaching-right-for-me] > a');
      menu.click();

      expect(document.querySelector('ol.primary > li[data-id=menu-is-teaching-right-for-me] > span.nav-icon').classList).toContain('nav-icon__arrow-up');
      expect(document.querySelector('div.category-links > ol.category-links-list#menu-is-teaching-right-for-me').classList).not.toContain('hidden-menu');

      menu.click();

      expect(document.querySelector('ol.primary > li[data-id=menu-is-teaching-right-for-me] > span.nav-icon').classList).toContain('nav-icon__arrow-down');
      expect(document.querySelector('div.category-links > ol.category-links-list#menu-is-teaching-right-for-me').classList).toContain('hidden-menu');
    });
  });
});
