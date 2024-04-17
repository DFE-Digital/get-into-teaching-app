import { Application } from '@hotwired/stimulus';
import NavigationController from 'navigation_controller.js';

describe('NavigationController', () => {
  describe('opening and closing the nav menu', () => {
    document.body.innerHTML = `
<header class="limit-content-width" data-controller="navigation" data-module="govuk-header">
  <div class="menu-button" id="mobile-navigation-menu-button">
    <button class="menu-button__button" id="menu-toggle" aria-expanded="false" aria-controls="primary-navigation" data-action="click->navigation#toggleNav" data-navigation-target="menu">
      <span class="menu-button__text">Menu</span>
      <span class="menu-button__icon"></span>
    </button>
  </div>
  <!-- mobile navigation -->
  <nav id="primary-navigation" class="hidden-mobile" data-navigation-target="nav" data-action="click->navigation#handleNavMenuClick" aria-label="Primary navigation" role="navigation">
    <ol class="primary" data-navigation-target="primary">
      <!-- "selectorsXXX": "ol.category-links-list, ol.page-links-list" -->
      <li id="is-teaching-right-for-me-mobile" class="" data-sync-id="is-teaching-right-for-me-desktop" data-child-menu-id="is-teaching-right-for-me-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-categories-desktop" data-direct-link="false">
        <a class="grow link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-categories-mobile is-teaching-right-for-me-categories-desktop" href="/is-teaching-right-for-me">Is teaching right for me?</a>
        <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
        <div class="break" aria-hidden="true"></div>
        <ol class="category-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-categories-mobile">
          <li id="is-teaching-right-for-me-pay-and-benefits-mobile" class="" data-sync-id="is-teaching-right-for-me-pay-and-benefits-desktop" data-child-menu-id="is-teaching-right-for-me-pay-and-benefits-pages-mobile" data-child-menu-sync-id="is-teaching-right-for-me-pay-and-benefits-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-pay-and-benefits-pages-mobile is-teaching-right-for-me-pay-and-benefits-pages-desktop" href="/is-teaching-right-for-me#pay-and-benefits" data-turbolinks="false">Pay and benefits</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-pay-and-benefits-pages-mobile">
              <li id="is-teaching-right-for-me-teacher-pay-and-benefits-mobile" class="" data-sync-id="is-teaching-right-for-me-teacher-pay-and-benefits-desktop" data-child-menu-id="is-teaching-right-for-me-teacher-pay-and-benefits-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-teacher-pay-and-benefits-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/teacher-pay-and-benefits">How much do teachers get paid?</a>
              </li>
              <li id="is-teaching-right-for-me-career-progression-mobile" class="" data-sync-id="is-teaching-right-for-me-career-progression-desktop" data-child-menu-id="is-teaching-right-for-me-career-progression-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-career-progression-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/career-progression">How can I move up the career ladder in teaching?</a>
              </li>
              <li id="is-teaching-right-for-me-what-pension-does-a-teacher-get-mobile" class="" data-sync-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-desktop" data-child-menu-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/what-pension-does-a-teacher-get">What pension does a teacher get?</a>
              </li>
            </ol>
          </li>
          <li id="is-teaching-right-for-me-qualifications-and-experience-mobile" class="" data-sync-id="is-teaching-right-for-me-qualifications-and-experience-desktop" data-child-menu-id="is-teaching-right-for-me-qualifications-and-experience-pages-mobile" data-child-menu-sync-id="is-teaching-right-for-me-qualifications-and-experience-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-qualifications-and-experience-pages-mobile is-teaching-right-for-me-qualifications-and-experience-pages-desktop" href="/is-teaching-right-for-me#qualifications-and-experience" data-turbolinks="false">Qualifications and experience</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-qualifications-and-experience-pages-mobile">
              <li id="is-teaching-right-for-me-qualifications-you-need-to-teach-mobile" class="" data-sync-id="is-teaching-right-for-me-qualifications-you-need-to-teach-desktop" data-child-menu-id="is-teaching-right-for-me-qualifications-you-need-to-teach-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-qualifications-you-need-to-teach-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/qualifications-you-need-to-teach">What qualifications do I need to be a teacher?</a>
              </li>
              <li id="is-teaching-right-for-me-if-you-want-to-change-career-mobile" class="" data-sync-id="is-teaching-right-for-me-if-you-want-to-change-career-desktop" data-child-menu-id="is-teaching-right-for-me-if-you-want-to-change-career-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-if-you-want-to-change-career-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/if-you-want-to-change-career">How do I change to a career in teaching?</a>
              </li>
            </ol>
          </li>
          <li id="is-teaching-right-for-me-who-to-teach-mobile" class="" data-sync-id="is-teaching-right-for-me-who-to-teach-desktop" data-child-menu-id="is-teaching-right-for-me-who-to-teach-pages-mobile" data-child-menu-sync-id="is-teaching-right-for-me-who-to-teach-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-who-to-teach-pages-mobile is-teaching-right-for-me-who-to-teach-pages-desktop" href="/is-teaching-right-for-me#who-to-teach" data-turbolinks="false">Who to teach</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-who-to-teach-pages-mobile">
              <li id="is-teaching-right-for-me-who-do-you-want-to-teach-mobile" class="" data-sync-id="is-teaching-right-for-me-who-do-you-want-to-teach-desktop" data-child-menu-id="is-teaching-right-for-me-who-do-you-want-to-teach-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-who-do-you-want-to-teach-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/who-do-you-want-to-teach">Which age group should I teach?</a>
              </li>
              <li id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-mobile" class="" data-sync-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-desktop" data-child-menu-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/teach-disabled-pupils-and-pupils-with-special-educational-needs">How can I teach children with special educational needs?</a>
              </li>
            </ol>
          </li>
          <li id="is-teaching-right-for-me-what-to-teach-mobile" class="" data-sync-id="is-teaching-right-for-me-what-to-teach-desktop" data-child-menu-id="is-teaching-right-for-me-what-to-teach-pages-mobile" data-child-menu-sync-id="is-teaching-right-for-me-what-to-teach-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-what-to-teach-pages-mobile is-teaching-right-for-me-what-to-teach-pages-desktop" href="/is-teaching-right-for-me#what-to-teach" data-turbolinks="false">What to teach</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-what-to-teach-pages-mobile">
              <li id="is-teaching-right-for-me-computing-mobile" class="" data-sync-id="is-teaching-right-for-me-computing-desktop" data-child-menu-id="is-teaching-right-for-me-computing-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-computing-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/computing">Computing</a>
              </li>
              <li id="is-teaching-right-for-me-maths-mobile" class="" data-sync-id="is-teaching-right-for-me-maths-desktop" data-child-menu-id="is-teaching-right-for-me-maths-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-maths-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/maths">Maths</a>
              </li>
              <li id="is-teaching-right-for-me-physics-mobile" class="" data-sync-id="is-teaching-right-for-me-physics-desktop" data-child-menu-id="is-teaching-right-for-me-physics-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-physics-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/physics">Physics</a>
              </li>
            </ol>
          </li>
          <li id="is-teaching-right-for-me-school-experience-mobile" class="" data-sync-id="is-teaching-right-for-me-school-experience-desktop" data-child-menu-id="is-teaching-right-for-me-school-experience-pages-mobile" data-child-menu-sync-id="is-teaching-right-for-me-school-experience-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-school-experience-pages-mobile is-teaching-right-for-me-school-experience-pages-desktop" href="/is-teaching-right-for-me#school-experience" data-turbolinks="false">School experience</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-school-experience-pages-mobile">
              <li id="is-teaching-right-for-me-get-school-experience-mobile" class="" data-sync-id="is-teaching-right-for-me-get-school-experience-desktop" data-child-menu-id="is-teaching-right-for-me-get-school-experience-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-get-school-experience-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/get-school-experience">How do I get experience in a school?</a>
              </li>
              <li id="is-teaching-right-for-me-teaching-internship-providers-mobile" class="" data-sync-id="is-teaching-right-for-me-teaching-internship-providers-desktop" data-child-menu-id="is-teaching-right-for-me-teaching-internship-providers-categories-mobile" data-child-menu-sync-id="is-teaching-right-for-me-teaching-internship-providers-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/teaching-internship-providers">Can I do a teaching internship?</a>
              </li>
            </ol>
          </li>
          <li class="view-all " data-id="menu-view-all-is-teaching-right-for-me" data-direct-link="true">
            <a class="link--black" href="/is-teaching-right-for-me">View all in Is teaching right for me?</a>
          </li>
        </ol>
      </li>
      <li id="steps-to-become-a-teacher-mobile" class="" data-sync-id="steps-to-become-a-teacher-desktop" data-child-menu-id="steps-to-become-a-teacher-categories-mobile" data-child-menu-sync-id="steps-to-become-a-teacher-categories-desktop" data-direct-link="true">
        <a class="grow link--black link--no-underline" href="/steps-to-become-a-teacher">How to become a teacher</a>
      </li>
      <li id="train-to-be-a-teacher-mobile" class="" data-sync-id="train-to-be-a-teacher-desktop" data-child-menu-id="train-to-be-a-teacher-categories-mobile" data-child-menu-sync-id="train-to-be-a-teacher-categories-desktop" data-direct-link="false">
        <a class="grow link--black link--no-underline" aria-expanded="false" aria-controls="train-to-be-a-teacher-categories-mobile train-to-be-a-teacher-categories-desktop" href="/train-to-be-a-teacher">Train to be a teacher</a>
        <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
        <div class="break" aria-hidden="true"></div>
        <ol class="category-links-list hidden-menu hidden-desktop" id="train-to-be-a-teacher-categories-mobile">
          <li id="train-to-be-a-teacher-postgraduate-teacher-training-mobile" class="" data-sync-id="train-to-be-a-teacher-postgraduate-teacher-training-desktop" data-child-menu-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile" data-child-menu-sync-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop" href="/train-to-be-a-teacher#postgraduate-teacher-training" data-turbolinks="false">Postgraduate teacher training</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile">
              <li id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-mobile" class="" data-sync-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-desktop" data-child-menu-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-mobile" data-child-menu-sync-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/train-to-be-a-teacher/how-to-choose-your-teacher-training-course">How to choose your course</a>
              </li>
              <li id="train-to-be-a-teacher-initial-teacher-training-mobile" class="" data-sync-id="train-to-be-a-teacher-initial-teacher-training-desktop" data-child-menu-id="train-to-be-a-teacher-initial-teacher-training-categories-mobile" data-child-menu-sync-id="train-to-be-a-teacher-initial-teacher-training-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/train-to-be-a-teacher/initial-teacher-training">What to expect in teacher training</a>
              </li>
            </ol>
          </li>
          <li id="train-to-be-a-teacher-qualifications-you-can-get-mobile" class="" data-sync-id="train-to-be-a-teacher-qualifications-you-can-get-desktop" data-child-menu-id="train-to-be-a-teacher-qualifications-you-can-get-pages-mobile" data-child-menu-sync-id="train-to-be-a-teacher-qualifications-you-can-get-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="train-to-be-a-teacher-qualifications-you-can-get-pages-mobile train-to-be-a-teacher-qualifications-you-can-get-pages-desktop" href="/train-to-be-a-teacher#qualifications-you-can-get" data-turbolinks="false">Qualifications you can get</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="train-to-be-a-teacher-qualifications-you-can-get-pages-mobile">
              <li id="train-to-be-a-teacher-what-is-qts-mobile" class="" data-sync-id="train-to-be-a-teacher-what-is-qts-desktop" data-child-menu-id="train-to-be-a-teacher-what-is-qts-categories-mobile" data-child-menu-sync-id="train-to-be-a-teacher-what-is-qts-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/train-to-be-a-teacher/what-is-qts">Qualified teacher status (QTS)</a>
              </li>
              <li id="train-to-be-a-teacher-what-is-a-pgce-mobile" class="" data-sync-id="train-to-be-a-teacher-what-is-a-pgce-desktop" data-child-menu-id="train-to-be-a-teacher-what-is-a-pgce-categories-mobile" data-child-menu-sync-id="train-to-be-a-teacher-what-is-a-pgce-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/train-to-be-a-teacher/what-is-a-pgce">Postgraduate certificate in education (PGCE)</a>
              </li>
            </ol>
          </li>
          <li class="view-all " data-id="menu-view-all-train-to-be-a-teacher" data-direct-link="true">
            <a class="link--black" href="/train-to-be-a-teacher">View all in Train to be a teacher</a>
          </li>
        </ol>
      </li>
      <li id="funding-and-support-mobile" class="" data-sync-id="funding-and-support-desktop" data-child-menu-id="funding-and-support-categories-mobile" data-child-menu-sync-id="funding-and-support-categories-desktop" data-direct-link="false">
        <a class="grow link--black link--no-underline" aria-expanded="false" aria-controls="funding-and-support-categories-mobile funding-and-support-categories-desktop" href="/funding-and-support">Fund your training</a>
        <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
        <div class="break" aria-hidden="true"></div>
        <ol class="category-links-list hidden-menu hidden-desktop" id="funding-and-support-categories-mobile">
          <li id="funding-and-support-extra-support-mobile" class="" data-sync-id="funding-and-support-extra-support-desktop" data-child-menu-id="funding-and-support-extra-support-pages-mobile" data-child-menu-sync-id="funding-and-support-extra-support-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="funding-and-support-extra-support-pages-mobile funding-and-support-extra-support-pages-desktop" href="/funding-and-support#extra-support" data-turbolinks="false">Extra support</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="funding-and-support-extra-support-pages-mobile">
              <li id="funding-and-support-if-youre-disabled-mobile" class="" data-sync-id="funding-and-support-if-youre-disabled-desktop" data-child-menu-id="funding-and-support-if-youre-disabled-categories-mobile" data-child-menu-sync-id="funding-and-support-if-youre-disabled-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/funding-and-support/if-youre-disabled">Funding and support if you're disabled</a>
              </li>
              <li id="funding-and-support-if-youre-a-parent-or-carer-mobile" class="" data-sync-id="funding-and-support-if-youre-a-parent-or-carer-desktop" data-child-menu-id="funding-and-support-if-youre-a-parent-or-carer-categories-mobile" data-child-menu-sync-id="funding-and-support-if-youre-a-parent-or-carer-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/funding-and-support/if-youre-a-parent-or-carer">Funding and support if you're a parent or carer</a>
              </li>
              <li id="funding-and-support-if-youre-a-veteran-mobile" class="" data-sync-id="funding-and-support-if-youre-a-veteran-desktop" data-child-menu-id="funding-and-support-if-youre-a-veteran-categories-mobile" data-child-menu-sync-id="funding-and-support-if-youre-a-veteran-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/funding-and-support/if-youre-a-veteran">Funding and support if you're a veteran</a>
              </li>
            </ol>
          </li>
          <li class="view-all " data-id="menu-view-all-funding-and-support" data-direct-link="true">
            <a class="link--black" href="/funding-and-support">View all in Fund your training</a>
          </li>
        </ol>
      </li>
      <li id="how-to-apply-for-teacher-training-mobile" class="" data-sync-id="how-to-apply-for-teacher-training-desktop" data-child-menu-id="how-to-apply-for-teacher-training-categories-mobile" data-child-menu-sync-id="how-to-apply-for-teacher-training-categories-desktop" data-direct-link="true">
        <a class="grow link--black link--no-underline" href="/how-to-apply-for-teacher-training">How to apply</a>
      </li>
      <li id="non-uk-teachers-mobile" class="" data-sync-id="non-uk-teachers-desktop" data-child-menu-id="non-uk-teachers-categories-mobile" data-child-menu-sync-id="non-uk-teachers-categories-desktop" data-direct-link="false">
        <a class="grow link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-categories-mobile non-uk-teachers-categories-desktop" href="/non-uk-teachers">Non-UK citizens</a>
        <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
        <div class="break" aria-hidden="true"></div>
        <ol class="category-links-list hidden-menu hidden-desktop" id="non-uk-teachers-categories-mobile">
          <li id="non-uk-teachers-if-you-want-to-train-to-teach-mobile" class="" data-sync-id="non-uk-teachers-if-you-want-to-train-to-teach-desktop" data-child-menu-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile" data-child-menu-sync-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop" href="/non-uk-teachers#if-you-want-to-train-to-teach" data-turbolinks="false">If you want to train to teach</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile">
              <li id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-mobile" class="" data-sync-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-desktop" data-child-menu-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-mobile" data-child-menu-sync-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/non-uk-teachers/train-to-teach-in-england-as-an-international-student">Train to teach in England as a non-UK citizen</a>
              </li>
              <li id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-mobile" class="" data-sync-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-desktop" data-child-menu-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-mobile" data-child-menu-sync-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/non-uk-teachers/fees-and-funding-for-non-uk-trainees">Fees and financial support for non-UK trainee teachers</a>
              </li>
              <li id="non-uk-teachers-non-uk-qualifications-mobile" class="" data-sync-id="non-uk-teachers-non-uk-qualifications-desktop" data-child-menu-id="non-uk-teachers-non-uk-qualifications-categories-mobile" data-child-menu-sync-id="non-uk-teachers-non-uk-qualifications-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/non-uk-teachers/non-uk-qualifications">Qualifications you'll need to train to teach in England</a>
              </li>
              <li id="non-uk-teachers-visas-for-non-uk-trainees-mobile" class="" data-sync-id="non-uk-teachers-visas-for-non-uk-trainees-desktop" data-child-menu-id="non-uk-teachers-visas-for-non-uk-trainees-categories-mobile" data-child-menu-sync-id="non-uk-teachers-visas-for-non-uk-trainees-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/non-uk-teachers/visas-for-non-uk-trainees">Apply for your visa to train to teach</a>
              </li>
            </ol>
          </li>
          <li id="non-uk-teachers-if-you-re-already-a-teacher-mobile" class="" data-sync-id="non-uk-teachers-if-you-re-already-a-teacher-desktop" data-child-menu-id="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile" data-child-menu-sync-id="non-uk-teachers-if-you-re-already-a-teacher-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile non-uk-teachers-if-you-re-already-a-teacher-pages-desktop" href="/non-uk-teachers#if-you-re-already-a-teacher" data-turbolinks="false">If you're already a teacher</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile">
              <li id="non-uk-teachers-teach-in-england-if-you-trained-overseas-mobile" class="" data-sync-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-desktop" data-child-menu-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-mobile" data-child-menu-sync-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/non-uk-teachers/teach-in-england-if-you-trained-overseas">Teach in England as a non-UK qualified teacher</a>
              </li>
              <li id="non-uk-teachers-get-an-international-relocation-payment-mobile" class="" data-sync-id="non-uk-teachers-get-an-international-relocation-payment-desktop" data-child-menu-id="non-uk-teachers-get-an-international-relocation-payment-categories-mobile" data-child-menu-sync-id="non-uk-teachers-get-an-international-relocation-payment-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/non-uk-teachers/get-an-international-relocation-payment">Get an international relocation payment</a>
              </li>
            </ol>
          </li>
          <li id="non-uk-teachers-get-international-qualified-teacher-status-iqts-mobile" class="" data-sync-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-desktop" data-child-menu-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile" data-child-menu-sync-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop" href="/non-uk-teachers#get-international-qualified-teacher-status-iqts" data-turbolinks="false">Get international qualified teacher status (iQTS)</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile">
              <li id="non-uk-teachers-international-qualified-teacher-status-mobile" class="" data-sync-id="non-uk-teachers-international-qualified-teacher-status-desktop" data-child-menu-id="non-uk-teachers-international-qualified-teacher-status-categories-mobile" data-child-menu-sync-id="non-uk-teachers-international-qualified-teacher-status-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/non-uk-teachers/international-qualified-teacher-status">Gain the equivalent of English QTS, from outside the UK</a>
              </li>
            </ol>
          </li>
          <li id="non-uk-teachers-if-you-re-from-ukraine-mobile" class="" data-sync-id="non-uk-teachers-if-you-re-from-ukraine-desktop" data-child-menu-id="non-uk-teachers-if-you-re-from-ukraine-pages-mobile" data-child-menu-sync-id="non-uk-teachers-if-you-re-from-ukraine-pages-desktop" data-direct-link="false">
            <a class="link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-from-ukraine-pages-mobile non-uk-teachers-if-you-re-from-ukraine-pages-desktop" href="/non-uk-teachers#if-you-re-from-ukraine" data-turbolinks="false">If you're from Ukraine</a>
            <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
            <div class="break" aria-hidden="true"></div>
            <ol class="page-links-list hidden-menu hidden-desktop" id="non-uk-teachers-if-you-re-from-ukraine-pages-mobile">
              <li id="non-uk-teachers-ukraine-mobile" class="" data-sync-id="non-uk-teachers-ukraine-desktop" data-child-menu-id="non-uk-teachers-ukraine-categories-mobile" data-child-menu-sync-id="non-uk-teachers-ukraine-categories-desktop" data-direct-link="true">
                <a class="grow link--black link--no-underline" href="/non-uk-teachers/ukraine">Ukrainian teachers and trainees coming to the UK</a>
              </li>
            </ol>
          </li>
          <li class="view-all " data-id="menu-view-all-non-uk-teachers" data-direct-link="true">
            <a class="link--black" href="/non-uk-teachers">View all in Non-UK citizens</a>
          </li>
        </ol>
      </li>
      <li id="help-and-support-mobile" class="" data-sync-id="help-and-support-desktop" data-child-menu-id="help-and-support-categories-mobile" data-child-menu-sync-id="help-and-support-categories-desktop" data-direct-link="true">
        <a class="grow link--black link--no-underline" href="/help-and-support">Get help and support</a>
      </li>
    </ol>
  </nav>
  <!-- desktop dropdown navigation -->
  <div id="secondary-navigation" class="desktop-menu-container hidden-mobile" data-navigation-target="desktop" data-action="click->navigation#handleNavMenuClick" aria-label="Secondary navigation" role="navigation">
    <div class="category-links">
      <ol class="category-links-list hidden-menu" id="is-teaching-right-for-me-categories-desktop">
        <li id="is-teaching-right-for-me-pay-and-benefits-desktop" class="" data-sync-id="is-teaching-right-for-me-pay-and-benefits-mobile" data-child-menu-id="is-teaching-right-for-me-pay-and-benefits-pages-desktop" data-child-menu-sync-id="is-teaching-right-for-me-pay-and-benefits-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-pay-and-benefits-pages-desktop is-teaching-right-for-me-pay-and-benefits-pages-mobile" href="/is-teaching-right-for-me#pay-and-benefits" data-turbolinks="false">Pay and benefits</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li id="is-teaching-right-for-me-qualifications-and-experience-desktop" class="" data-sync-id="is-teaching-right-for-me-qualifications-and-experience-mobile" data-child-menu-id="is-teaching-right-for-me-qualifications-and-experience-pages-desktop" data-child-menu-sync-id="is-teaching-right-for-me-qualifications-and-experience-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-qualifications-and-experience-pages-desktop is-teaching-right-for-me-qualifications-and-experience-pages-mobile" href="/is-teaching-right-for-me#qualifications-and-experience" data-turbolinks="false">Qualifications and experience</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li id="is-teaching-right-for-me-who-to-teach-desktop" class="" data-sync-id="is-teaching-right-for-me-who-to-teach-mobile" data-child-menu-id="is-teaching-right-for-me-who-to-teach-pages-desktop" data-child-menu-sync-id="is-teaching-right-for-me-who-to-teach-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-who-to-teach-pages-desktop is-teaching-right-for-me-who-to-teach-pages-mobile" href="/is-teaching-right-for-me#who-to-teach" data-turbolinks="false">Who to teach</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li id="is-teaching-right-for-me-what-to-teach-desktop" class="" data-sync-id="is-teaching-right-for-me-what-to-teach-mobile" data-child-menu-id="is-teaching-right-for-me-what-to-teach-pages-desktop" data-child-menu-sync-id="is-teaching-right-for-me-what-to-teach-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-what-to-teach-pages-desktop is-teaching-right-for-me-what-to-teach-pages-mobile" href="/is-teaching-right-for-me#what-to-teach" data-turbolinks="false">What to teach</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li id="is-teaching-right-for-me-school-experience-desktop" class="" data-sync-id="is-teaching-right-for-me-school-experience-mobile" data-child-menu-id="is-teaching-right-for-me-school-experience-pages-desktop" data-child-menu-sync-id="is-teaching-right-for-me-school-experience-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-school-experience-pages-desktop is-teaching-right-for-me-school-experience-pages-mobile" href="/is-teaching-right-for-me#school-experience" data-turbolinks="false">School experience</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li class="view-all " data-id="menu-view-all-is-teaching-right-for-me" data-direct-link="true">
          <a class="link--black" href="/is-teaching-right-for-me">View all in Is teaching right for me?</a>
        </li>
      </ol>
      <ol class="category-links-list hidden-menu" id="train-to-be-a-teacher-categories-desktop">
        <li id="train-to-be-a-teacher-postgraduate-teacher-training-desktop" class="" data-sync-id="train-to-be-a-teacher-postgraduate-teacher-training-mobile" data-child-menu-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop" data-child-menu-sync-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile" href="/train-to-be-a-teacher#postgraduate-teacher-training" data-turbolinks="false">Postgraduate teacher training</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li id="train-to-be-a-teacher-qualifications-you-can-get-desktop" class="" data-sync-id="train-to-be-a-teacher-qualifications-you-can-get-mobile" data-child-menu-id="train-to-be-a-teacher-qualifications-you-can-get-pages-desktop" data-child-menu-sync-id="train-to-be-a-teacher-qualifications-you-can-get-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="train-to-be-a-teacher-qualifications-you-can-get-pages-desktop train-to-be-a-teacher-qualifications-you-can-get-pages-mobile" href="/train-to-be-a-teacher#qualifications-you-can-get" data-turbolinks="false">Qualifications you can get</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li class="view-all " data-id="menu-view-all-train-to-be-a-teacher" data-direct-link="true">
          <a class="link--black" href="/train-to-be-a-teacher">View all in Train to be a teacher</a>
        </li>
      </ol>
      <ol class="category-links-list hidden-menu" id="funding-and-support-categories-desktop">
        <li id="funding-and-support-extra-support-desktop" class="" data-sync-id="funding-and-support-extra-support-mobile" data-child-menu-id="funding-and-support-extra-support-pages-desktop" data-child-menu-sync-id="funding-and-support-extra-support-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="funding-and-support-extra-support-pages-desktop funding-and-support-extra-support-pages-mobile" href="/funding-and-support#extra-support" data-turbolinks="false">Extra support</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li class="view-all " data-id="menu-view-all-funding-and-support" data-direct-link="true">
          <a class="link--black" href="/funding-and-support">View all in Fund your training</a>
        </li>
      </ol>
      <ol class="category-links-list hidden-menu" id="non-uk-teachers-categories-desktop">
        <li id="non-uk-teachers-if-you-want-to-train-to-teach-desktop" class="" data-sync-id="non-uk-teachers-if-you-want-to-train-to-teach-mobile" data-child-menu-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop" data-child-menu-sync-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile" href="/non-uk-teachers#if-you-want-to-train-to-teach" data-turbolinks="false">If you want to train to teach</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li id="non-uk-teachers-if-you-re-already-a-teacher-desktop" class="" data-sync-id="non-uk-teachers-if-you-re-already-a-teacher-mobile" data-child-menu-id="non-uk-teachers-if-you-re-already-a-teacher-pages-desktop" data-child-menu-sync-id="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-already-a-teacher-pages-desktop non-uk-teachers-if-you-re-already-a-teacher-pages-mobile" href="/non-uk-teachers#if-you-re-already-a-teacher" data-turbolinks="false">If you're already a teacher</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li id="non-uk-teachers-get-international-qualified-teacher-status-iqts-desktop" class="" data-sync-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-mobile" data-child-menu-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop" data-child-menu-sync-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile" href="/non-uk-teachers#get-international-qualified-teacher-status-iqts" data-turbolinks="false">Get international qualified teacher status (iQTS)</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li id="non-uk-teachers-if-you-re-from-ukraine-desktop" class="" data-sync-id="non-uk-teachers-if-you-re-from-ukraine-mobile" data-child-menu-id="non-uk-teachers-if-you-re-from-ukraine-pages-desktop" data-child-menu-sync-id="non-uk-teachers-if-you-re-from-ukraine-pages-mobile" data-direct-link="false">
          <a class="link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-from-ukraine-pages-desktop non-uk-teachers-if-you-re-from-ukraine-pages-mobile" href="/non-uk-teachers#if-you-re-from-ukraine" data-turbolinks="false">If you're from Ukraine</a>
          <span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
          <div class="break" aria-hidden="true"></div>
        </li>
        <li class="view-all " data-id="menu-view-all-non-uk-teachers" data-direct-link="true">
          <a class="link--black" href="/non-uk-teachers">View all in Non-UK citizens</a>
        </li>
      </ol>
    </div>
    <div class="page-links">
      <ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-pay-and-benefits-pages-desktop">
        <li id="is-teaching-right-for-me-teacher-pay-and-benefits-desktop" class="" data-sync-id="is-teaching-right-for-me-teacher-pay-and-benefits-mobile" data-child-menu-id="is-teaching-right-for-me-teacher-pay-and-benefits-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-teacher-pay-and-benefits-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/teacher-pay-and-benefits">How much do teachers get paid?</a>
        </li>
        <li id="is-teaching-right-for-me-career-progression-desktop" class="" data-sync-id="is-teaching-right-for-me-career-progression-mobile" data-child-menu-id="is-teaching-right-for-me-career-progression-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-career-progression-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/career-progression">How can I move up the career ladder in teaching?</a>
        </li>
        <li id="is-teaching-right-for-me-what-pension-does-a-teacher-get-desktop" class="" data-sync-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-mobile" data-child-menu-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/what-pension-does-a-teacher-get">What pension does a teacher get?</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-qualifications-and-experience-pages-desktop">
        <li id="is-teaching-right-for-me-qualifications-you-need-to-teach-desktop" class="" data-sync-id="is-teaching-right-for-me-qualifications-you-need-to-teach-mobile" data-child-menu-id="is-teaching-right-for-me-qualifications-you-need-to-teach-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-qualifications-you-need-to-teach-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/qualifications-you-need-to-teach">What qualifications do I need to be a teacher?</a>
        </li>
        <li id="is-teaching-right-for-me-if-you-want-to-change-career-desktop" class="" data-sync-id="is-teaching-right-for-me-if-you-want-to-change-career-mobile" data-child-menu-id="is-teaching-right-for-me-if-you-want-to-change-career-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-if-you-want-to-change-career-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/if-you-want-to-change-career">How do I change to a career in teaching?</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-who-to-teach-pages-desktop">
        <li id="is-teaching-right-for-me-who-do-you-want-to-teach-desktop" class="" data-sync-id="is-teaching-right-for-me-who-do-you-want-to-teach-mobile" data-child-menu-id="is-teaching-right-for-me-who-do-you-want-to-teach-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-who-do-you-want-to-teach-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/who-do-you-want-to-teach">Which age group should I teach?</a>
        </li>
        <li id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-desktop" class="" data-sync-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-mobile" data-child-menu-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/teach-disabled-pupils-and-pupils-with-special-educational-needs">How can I teach children with special educational needs?</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-what-to-teach-pages-desktop">
        <li id="is-teaching-right-for-me-computing-desktop" class="" data-sync-id="is-teaching-right-for-me-computing-mobile" data-child-menu-id="is-teaching-right-for-me-computing-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-computing-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/computing">Computing</a>
        </li>
        <li id="is-teaching-right-for-me-maths-desktop" class="" data-sync-id="is-teaching-right-for-me-maths-mobile" data-child-menu-id="is-teaching-right-for-me-maths-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-maths-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/maths">Maths</a>
        </li>
        <li id="is-teaching-right-for-me-physics-desktop" class="" data-sync-id="is-teaching-right-for-me-physics-mobile" data-child-menu-id="is-teaching-right-for-me-physics-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-physics-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/physics">Physics</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-school-experience-pages-desktop">
        <li id="is-teaching-right-for-me-get-school-experience-desktop" class="" data-sync-id="is-teaching-right-for-me-get-school-experience-mobile" data-child-menu-id="is-teaching-right-for-me-get-school-experience-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-get-school-experience-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/get-school-experience">How do I get experience in a school?</a>
        </li>
        <li id="is-teaching-right-for-me-teaching-internship-providers-desktop" class="" data-sync-id="is-teaching-right-for-me-teaching-internship-providers-mobile" data-child-menu-id="is-teaching-right-for-me-teaching-internship-providers-categories-desktop" data-child-menu-sync-id="is-teaching-right-for-me-teaching-internship-providers-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/is-teaching-right-for-me/teaching-internship-providers">Can I do a teaching internship?</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop">
        <li id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-desktop" class="" data-sync-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-mobile" data-child-menu-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-desktop" data-child-menu-sync-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/train-to-be-a-teacher/how-to-choose-your-teacher-training-course">How to choose your course</a>
        </li>
        <li id="train-to-be-a-teacher-initial-teacher-training-desktop" class="" data-sync-id="train-to-be-a-teacher-initial-teacher-training-mobile" data-child-menu-id="train-to-be-a-teacher-initial-teacher-training-categories-desktop" data-child-menu-sync-id="train-to-be-a-teacher-initial-teacher-training-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/train-to-be-a-teacher/initial-teacher-training">What to expect in teacher training</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="train-to-be-a-teacher-qualifications-you-can-get-pages-desktop">
        <li id="train-to-be-a-teacher-what-is-qts-desktop" class="" data-sync-id="train-to-be-a-teacher-what-is-qts-mobile" data-child-menu-id="train-to-be-a-teacher-what-is-qts-categories-desktop" data-child-menu-sync-id="train-to-be-a-teacher-what-is-qts-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/train-to-be-a-teacher/what-is-qts">Qualified teacher status (QTS)</a>
        </li>
        <li id="train-to-be-a-teacher-what-is-a-pgce-desktop" class="" data-sync-id="train-to-be-a-teacher-what-is-a-pgce-mobile" data-child-menu-id="train-to-be-a-teacher-what-is-a-pgce-categories-desktop" data-child-menu-sync-id="train-to-be-a-teacher-what-is-a-pgce-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/train-to-be-a-teacher/what-is-a-pgce">Postgraduate certificate in education (PGCE)</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="funding-and-support-extra-support-pages-desktop">
        <li id="funding-and-support-if-youre-disabled-desktop" class="" data-sync-id="funding-and-support-if-youre-disabled-mobile" data-child-menu-id="funding-and-support-if-youre-disabled-categories-desktop" data-child-menu-sync-id="funding-and-support-if-youre-disabled-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/funding-and-support/if-youre-disabled">Funding and support if you're disabled</a>
        </li>
        <li id="funding-and-support-if-youre-a-parent-or-carer-desktop" class="" data-sync-id="funding-and-support-if-youre-a-parent-or-carer-mobile" data-child-menu-id="funding-and-support-if-youre-a-parent-or-carer-categories-desktop" data-child-menu-sync-id="funding-and-support-if-youre-a-parent-or-carer-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/funding-and-support/if-youre-a-parent-or-carer">Funding and support if you're a parent or carer</a>
        </li>
        <li id="funding-and-support-if-youre-a-veteran-desktop" class="" data-sync-id="funding-and-support-if-youre-a-veteran-mobile" data-child-menu-id="funding-and-support-if-youre-a-veteran-categories-desktop" data-child-menu-sync-id="funding-and-support-if-youre-a-veteran-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/funding-and-support/if-youre-a-veteran">Funding and support if you're a veteran</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop">
        <li id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-desktop" class="" data-sync-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-mobile" data-child-menu-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-desktop" data-child-menu-sync-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/non-uk-teachers/train-to-teach-in-england-as-an-international-student">Train to teach in England as a non-UK citizen</a>
        </li>
        <li id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-desktop" class="" data-sync-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-mobile" data-child-menu-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-desktop" data-child-menu-sync-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/non-uk-teachers/fees-and-funding-for-non-uk-trainees">Fees and financial support for non-UK trainee teachers</a>
        </li>
        <li id="non-uk-teachers-non-uk-qualifications-desktop" class="" data-sync-id="non-uk-teachers-non-uk-qualifications-mobile" data-child-menu-id="non-uk-teachers-non-uk-qualifications-categories-desktop" data-child-menu-sync-id="non-uk-teachers-non-uk-qualifications-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/non-uk-teachers/non-uk-qualifications">Qualifications you'll need to train to teach in England</a>
        </li>
        <li id="non-uk-teachers-visas-for-non-uk-trainees-desktop" class="" data-sync-id="non-uk-teachers-visas-for-non-uk-trainees-mobile" data-child-menu-id="non-uk-teachers-visas-for-non-uk-trainees-categories-desktop" data-child-menu-sync-id="non-uk-teachers-visas-for-non-uk-trainees-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/non-uk-teachers/visas-for-non-uk-trainees">Apply for your visa to train to teach</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="non-uk-teachers-if-you-re-already-a-teacher-pages-desktop">
        <li id="non-uk-teachers-teach-in-england-if-you-trained-overseas-desktop" class="" data-sync-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-mobile" data-child-menu-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-desktop" data-child-menu-sync-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/non-uk-teachers/teach-in-england-if-you-trained-overseas">Teach in England as a non-UK qualified teacher</a>
        </li>
        <li id="non-uk-teachers-get-an-international-relocation-payment-desktop" class="" data-sync-id="non-uk-teachers-get-an-international-relocation-payment-mobile" data-child-menu-id="non-uk-teachers-get-an-international-relocation-payment-categories-desktop" data-child-menu-sync-id="non-uk-teachers-get-an-international-relocation-payment-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/non-uk-teachers/get-an-international-relocation-payment">Get an international relocation payment</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop">
        <li id="non-uk-teachers-international-qualified-teacher-status-desktop" class="" data-sync-id="non-uk-teachers-international-qualified-teacher-status-mobile" data-child-menu-id="non-uk-teachers-international-qualified-teacher-status-categories-desktop" data-child-menu-sync-id="non-uk-teachers-international-qualified-teacher-status-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/non-uk-teachers/international-qualified-teacher-status">Gain the equivalent of English QTS, from outside the UK</a>
        </li>
      </ol>
      <ol class="page-links-list hidden-menu" id="non-uk-teachers-if-you-re-from-ukraine-pages-desktop">
        <li id="non-uk-teachers-ukraine-desktop" class="" data-sync-id="non-uk-teachers-ukraine-mobile" data-child-menu-id="non-uk-teachers-ukraine-categories-desktop" data-child-menu-sync-id="non-uk-teachers-ukraine-categories-mobile" data-direct-link="true">
          <a class="grow link--black link--no-underline" href="/non-uk-teachers/ukraine">Ukrainian teachers and trainees coming to the UK</a>
        </li>
      </ol>
    </div>
    <div class="key-links"></div>
  </div>
</header>
`;

    const application = Application.start();
    application.register('navigation', NavigationController);

    it('toggles the visibility of the navigation area when menu button clicked', () => {
      const nav = document.querySelector('nav');
      const button = document.querySelector('button');

      expect(nav.classList).toContain('hidden-mobile');

      button.click();

      expect(nav.classList).not.toContain('hidden-mobile');

      button.click();

      expect(nav.classList).toContain('hidden-mobile');
    });

    it('toggles the dropdown menu when a primary menu item is clicked', () => {
      const primaryLink = document.querySelector('#is-teaching-right-for-me-mobile > a');
      const icon = document.querySelector('#is-teaching-right-for-me-mobile > span.nav-icon');
      const menu = document.getElementById('is-teaching-right-for-me-categories-desktop');

      expect(icon.classList).toContain('nav-icon__contracted');
      expect(menu.classList).toContain('hidden-menu');

      primaryLink.click();

      expect(icon.classList).toContain('nav-icon__expanded');
      expect(menu.classList).not.toContain('hidden-menu');

      primaryLink.click();

      expect(icon.classList).toContain('nav-icon__contracted');
      expect(menu.classList).toContain('hidden-menu');
    });
  });
});
