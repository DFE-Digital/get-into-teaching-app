import { Application } from '@hotwired/stimulus';
import NavigationController from 'navigation_controller.js';

describe('NavigationController', () => {
  describe('opening and closing the nav menu', () => {
    document.body.innerHTML = `
<header class="limit-content-width" data-controller="navigation" data-module="govuk-header">
  <div class="extra-navigation" data-controller="searchbox" data-searchbox-search-input-id-value="searchbox__input--desktop" role="navigation">
  <ul class="extra-navigation__list extra-navigation__flex">
    <li class="extra-navigation__link extra-navigation__mail">
      <a class="link--black" href="/mailinglist/signup/name">
        Sign up for emails<span class="icon icon-mail hide-on-narrow" aria-hidden="true"></span><span class="icon icon-mail-white hide-on-narrow" aria-hidden="true"></span>
</a>    </li>
    <li class="extra-navigation__link extra-navigation__calendar">
      <a class="link--black" href="/events">
        Upcoming events<span class="icon icon-calendar hide-on-narrow" aria-hidden="true"></span><span class="icon icon-calendar-white hide-on-narrow" aria-hidden="true"></span>
</a>    </li>
    <li class="extra-navigation__link extra-navigation__search">
      <label for="searchbox__input--desktop" class="searchbox__label visually-hidden hidden" data-searchbox-target="label">Search</label>
      <a id="search-toggle" role="button" aria-label="Search" aria-expanded="false" aria-controls="search-bar" data-action="searchbox#toggle" href="/search">
        <span class="icon icon-search"></span>
        <span class="icon icon-close"></span>
</a>
</li>  </ul>
  <div id="search-bar" class="searchbar" data-searchbox-target="searchbar" role="search"><div class="autocomplete__wrapper"><div class="autocomplete__status" style="border: 0px; clip: rect(0px, 0px, 0px, 0px); height: 1px; margin-bottom: -1px; margin-right: -1px; overflow: hidden; padding: 0px; position: absolute; white-space: nowrap; width: 1px;"><div id="searchbox__input--desktop__status--A" role="status" aria-atomic="true" aria-live="polite"></div><div id="searchbox__input--desktop__status--B" role="status" aria-atomic="true" aria-live="polite"></div></div><input aria-describedby="searchbox__input--desktop__assistiveHint" aria-expanded="false" aria-owns="searchbox__input--desktop__listbox" aria-autocomplete="list" autocomplete="off" class="autocomplete__input autocomplete__input--default" id="searchbox__input--desktop" name="input-autocomplete" placeholder="Search" type="text" role="combobox" aria-label="Search"><ul id="searchbox__input--desktop__listbox" role="listbox" class="autocomplete__menu autocomplete__menu--overlay autocomplete__menu--hidden"></ul><span id="searchbox__input--desktop__assistiveHint" style="display: none;">When autocomplete results are available use up and down arrows to review and enter to select.  Touch device users, explore by touch or with swipe gestures.</span></div></div>
</div>
  <div class="logo-wrapper">
  <div class="logo">
    <a href="/" class="logo__image">
      <picture><source srcset="/packs/v1/static/images/logo/teaching_blue_background-b1b9e8f9c3c482b7f3d7.svg" type="image/svg+xml"><img alt="Go to the Get Into Teaching homepage, Teaching Every Lesson Shapes a Life logo" data-lazy-disable="true" src="/packs/v1/static/images/logo/teaching_blue_background-b1b9e8f9c3c482b7f3d7.svg" width="286" height="113"></picture>
      <picture><source srcset="/packs/v1/static/images/logo/teaching_black_background_pink_underline-334ce8fd4e1f43027fba.svg" type="image/svg+xml"><img alt="Go to the Get Into Teaching homepage, Teaching Every Lesson Shapes a Life logo" data-lazy-disable="true" src="/packs/v1/static/images/logo/teaching_black_background_pink_underline-334ce8fd4e1f43027fba.svg" width="286" height="113"></picture>
    </a>
  </div>
</div>

  <div class="menu-button" id="mobile-navigation-menu-button">
    <a class="menu-button__button hidden-when-js-enabled" href="/browse">
      <span class="menu-button__text">Menu</span>
</a>    <button class="menu-button__button hidden-when-js-disabled" id="menu-toggle" aria-expanded="false" aria-controls="primary-navigation" data-action="click->navigation#toggleNav keydown.enter->navigation#toggleNav" data-navigation-target="menu">
      <span class="menu-button__text">Menu</span>
      <span class="menu-button__icon"></span>
</button>  </div>
  <!-- navigation -->
<nav id="primary-navigation" class="hidden-mobile" data-navigation-target="nav" data-action="click->navigation#handleNavMenuClick" aria-label="Primary navigation" role="navigation">
  <ol class="primary" data-navigation-target="primary">
      <li id="life-as-a-teacher-mobile" class="" data-child-menu-id="life-as-a-teacher-categories-mobile" data-direct-link="false">
<a class="menu-link link link--black link--no-underline " role="menuitem" aria-expanded="false" aria-controls="life-as-a-teacher-categories-mobile" data-action="keydown.enter->navigation#handleNavMenuClick" href="/life-as-a-teacher"><span class="menu-title">Life as a teacher</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></a><div class="break" aria-hidden="true"></div>
<div class="desktop-level2-wrapper"><ol class="category-links-list hidden-menu" id="life-as-a-teacher-categories-mobile" role="menu">
<li id="life-as-a-teacher-pay-and-benefits-mobile" class="" data-child-menu-id="life-as-a-teacher-pay-and-benefits-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/life-as-a-teacher/pay-and-benefits"><span class="menu-title">Pay and benefits</span></a></li>
<li id="life-as-a-teacher-why-teach-mobile" class="" data-child-menu-id="life-as-a-teacher-why-teach-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/life-as-a-teacher/why-teach"><span class="menu-title">Why teach</span></a></li>
<li id="life-as-a-teacher-teaching-as-a-career-mobile" class="" data-child-menu-id="life-as-a-teacher-teaching-as-a-career-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/life-as-a-teacher/teaching-as-a-career"><span class="menu-title">Teaching as a career</span></a></li>
<li id="life-as-a-teacher-explore-subjects-mobile" class="" data-child-menu-id="life-as-a-teacher-explore-subjects-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/life-as-a-teacher/explore-subjects"><span class="menu-title">Explore subjects</span></a></li>
<li id="life-as-a-teacher-age-groups-and-specialisms-mobile" class="" data-child-menu-id="life-as-a-teacher-age-groups-and-specialisms-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/life-as-a-teacher/age-groups-and-specialisms"><span class="menu-title">Age groups and specialisms</span></a></li>
<li id="life-as-a-teacher-change-careers-mobile" class="" data-child-menu-id="life-as-a-teacher-change-careers-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/life-as-a-teacher/change-careers"><span class="menu-title">Change to a career in teaching</span></a></li>
<li class="view-all " id="menu-view-all-life-as-a-teacher-mobile" data-direct-link="true"><a class="menu-link link link--black" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/life-as-a-teacher"><span class="menu-title">View all in Life as a teacher</span></a></li>
</ol></div>
</li>
      <li id="steps-to-become-a-teacher-mobile" class="" data-child-menu-id="steps-to-become-a-teacher-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline " role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/steps-to-become-a-teacher"><span class="menu-title">How to become a teacher</span></a></li>
      <li id="train-to-be-a-teacher-mobile" class="" data-child-menu-id="train-to-be-a-teacher-categories-mobile" data-direct-link="false">
<a class="menu-link link link--black link--no-underline " role="menuitem" aria-expanded="false" aria-controls="train-to-be-a-teacher-categories-mobile" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher"><span class="menu-title">Train to be a teacher</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></a><div class="break" aria-hidden="true"></div>
<div class="desktop-level2-wrapper"><ol class="category-links-list hidden-menu" id="train-to-be-a-teacher-categories-mobile" role="menu">
<li id="train-to-be-a-teacher-postgraduate-teacher-training-mobile" class="" data-child-menu-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">Postgraduate teacher training</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile">
<li id="train-to-be-a-teacher-if-you-have-a-degree-mobile" class="" data-child-menu-id="train-to-be-a-teacher-if-you-have-a-degree-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/if-you-have-a-degree"><span class="menu-title">If you have or are studying for a degree</span></a></li>
<li id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-mobile" class="" data-child-menu-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/how-to-choose-your-teacher-training-course"><span class="menu-title">How to choose your course</span></a></li>
<li id="train-to-be-a-teacher-initial-teacher-training-mobile" class="" data-child-menu-id="train-to-be-a-teacher-initial-teacher-training-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/initial-teacher-training"><span class="menu-title">What to expect in teacher training</span></a></li>
<li id="train-to-be-a-teacher-school-placements-mobile" class="" data-child-menu-id="train-to-be-a-teacher-school-placements-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/school-placements"><span class="menu-title">Teacher training school placements</span></a></li>
<li id="train-to-be-a-teacher-accessibility-adjustments-mobile" class="" data-child-menu-id="train-to-be-a-teacher-accessibility-adjustments-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/accessibility-adjustments"><span class="menu-title">Adjustments to help you train</span></a></li>
<li id="train-to-be-a-teacher-get-school-experience-mobile" class="" data-child-menu-id="train-to-be-a-teacher-get-school-experience-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/get-school-experience"><span class="menu-title">Get school experience</span></a></li>
<li id="train-to-be-a-teacher-teaching-internships-mobile" class="" data-child-menu-id="train-to-be-a-teacher-teaching-internships-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/teaching-internships"><span class="menu-title">Teaching internships</span></a></li>
</ol></div>
</li>
<li id="train-to-be-a-teacher-qualifications-mobile" class="" data-child-menu-id="train-to-be-a-teacher-qualifications-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="train-to-be-a-teacher-qualifications-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">Qualifications</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="train-to-be-a-teacher-qualifications-pages-mobile">
<li id="train-to-be-a-teacher-qualifications-you-need-to-teach-mobile" class="" data-child-menu-id="train-to-be-a-teacher-qualifications-you-need-to-teach-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/qualifications-you-need-to-teach"><span class="menu-title">Qualifications you need to be a teacher</span></a></li>
<li id="train-to-be-a-teacher-what-is-qts-mobile" class="" data-child-menu-id="train-to-be-a-teacher-what-is-qts-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/what-is-qts"><span class="menu-title">Qualified teacher status (QTS)</span></a></li>
<li id="train-to-be-a-teacher-what-is-a-pgce-mobile" class="" data-child-menu-id="train-to-be-a-teacher-what-is-a-pgce-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/what-is-a-pgce"><span class="menu-title">Postgraduate certificate in education (PGCE)</span></a></li>
</ol></div>
</li>
<li id="train-to-be-a-teacher-other-routes-into-teaching-mobile" class="" data-child-menu-id="train-to-be-a-teacher-other-routes-into-teaching-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="train-to-be-a-teacher-other-routes-into-teaching-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">Other routes into teaching</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="train-to-be-a-teacher-other-routes-into-teaching-pages-mobile">
<li id="train-to-be-a-teacher-if-you-dont-have-a-degree-mobile" class="" data-child-menu-id="train-to-be-a-teacher-if-you-dont-have-a-degree-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/if-you-dont-have-a-degree"><span class="menu-title">If you do not have a degree</span></a></li>
<li id="train-to-be-a-teacher-assessment-only-route-to-qts-mobile" class="" data-child-menu-id="train-to-be-a-teacher-assessment-only-route-to-qts-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/assessment-only-route-to-qts"><span class="menu-title">If you’ve worked as an unqualified teacher</span></a></li>
<li id="train-to-be-a-teacher-teacher-degree-apprenticeships-mobile" class="" data-child-menu-id="train-to-be-a-teacher-teacher-degree-apprenticeships-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher/teacher-degree-apprenticeships"><span class="menu-title">If you want to do a teaching apprenticeship</span></a></li>
</ol></div>
</li>
<li class="view-all " id="menu-view-all-train-to-be-a-teacher-mobile" data-direct-link="true"><a class="menu-link link link--black" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/train-to-be-a-teacher"><span class="menu-title">View all in Train to be a teacher</span></a></li>
</ol></div>
</li>
      <li id="funding-and-support-mobile" class="" data-child-menu-id="funding-and-support-categories-mobile" data-direct-link="false">
<a class="menu-link link link--black link--no-underline " role="menuitem" aria-expanded="false" aria-controls="funding-and-support-categories-mobile" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support"><span class="menu-title">Fund your training</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></a><div class="break" aria-hidden="true"></div>
<div class="desktop-level2-wrapper"><ol class="category-links-list hidden-menu" id="funding-and-support-categories-mobile" role="menu">
<li id="funding-and-support-courses-with-fees-mobile" class="" data-child-menu-id="funding-and-support-courses-with-fees-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="funding-and-support-courses-with-fees-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">Courses with fees</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="funding-and-support-courses-with-fees-pages-mobile">
<li id="funding-and-support-tuition-fees-mobile" class="" data-child-menu-id="funding-and-support-tuition-fees-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support/tuition-fees"><span class="menu-title">Tuition fees</span></a></li>
<li id="funding-and-support-tuition-fee-and-maintenance-loans-mobile" class="" data-child-menu-id="funding-and-support-tuition-fee-and-maintenance-loans-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support/tuition-fee-and-maintenance-loans"><span class="menu-title">Student finance for teacher training</span></a></li>
<li id="funding-and-support-scholarships-and-bursaries-mobile" class="" data-child-menu-id="funding-and-support-scholarships-and-bursaries-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support/scholarships-and-bursaries"><span class="menu-title">Bursaries and scholarships</span></a></li>
</ol></div>
</li>
<li id="funding-and-support-courses-with-a-salary-mobile" class="" data-child-menu-id="funding-and-support-courses-with-a-salary-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="funding-and-support-courses-with-a-salary-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">Courses with a salary</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="funding-and-support-courses-with-a-salary-pages-mobile"><li id="funding-and-support-salaried-teacher-training-mobile" class="" data-child-menu-id="funding-and-support-salaried-teacher-training-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support/salaried-teacher-training"><span class="menu-title">Postgraduate salaried teacher training</span></a></li></ol></div>
</li>
<li id="funding-and-support-extra-support-mobile" class="" data-child-menu-id="funding-and-support-extra-support-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="funding-and-support-extra-support-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">Extra support</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="funding-and-support-extra-support-pages-mobile">
<li id="funding-and-support-if-youre-disabled-mobile" class="" data-child-menu-id="funding-and-support-if-youre-disabled-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support/if-youre-disabled"><span class="menu-title">Funding and support if you have a learning difficulty, health condition or disability</span></a></li>
<li id="funding-and-support-if-youre-a-parent-or-carer-mobile" class="" data-child-menu-id="funding-and-support-if-youre-a-parent-or-carer-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support/if-youre-a-parent-or-carer"><span class="menu-title">Funding and support if you're a parent or carer</span></a></li>
<li id="funding-and-support-if-youre-a-veteran-mobile" class="" data-child-menu-id="funding-and-support-if-youre-a-veteran-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support/if-youre-a-veteran"><span class="menu-title">Funding and support if you're a veteran</span></a></li>
</ol></div>
</li>
<li class="view-all " id="menu-view-all-funding-and-support-mobile" data-direct-link="true"><a class="menu-link link link--black" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/funding-and-support"><span class="menu-title">View all in Fund your training</span></a></li>
</ol></div>
</li>
      <li id="how-to-apply-for-teacher-training-mobile" class="" data-child-menu-id="how-to-apply-for-teacher-training-categories-mobile" data-direct-link="false">
<a class="menu-link link link--black link--no-underline " role="menuitem" aria-expanded="false" aria-controls="how-to-apply-for-teacher-training-categories-mobile" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training"><span class="menu-title">How to apply</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></a><div class="break" aria-hidden="true"></div>
<div class="desktop-level2-wrapper"><ol class="category-links-list hidden-menu" id="how-to-apply-for-teacher-training-categories-mobile" role="menu">
<li id="how-to-apply-for-teacher-training-teacher-training-application-mobile" class="" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-application-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training/teacher-training-application"><span class="menu-title">Teacher training application</span></a></li>
<li id="how-to-apply-for-teacher-training-teacher-training-personal-statement-mobile" class="" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-personal-statement-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training/teacher-training-personal-statement"><span class="menu-title">Teacher training personal statement</span></a></li>
<li id="how-to-apply-for-teacher-training-teacher-training-references-mobile" class="" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-references-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training/teacher-training-references"><span class="menu-title">Teacher training references</span></a></li>
<li id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-mobile" class="" data-child-menu-id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training/when-to-apply-for-teacher-training"><span class="menu-title">When to apply for teacher training</span></a></li>
<li id="how-to-apply-for-teacher-training-teacher-training-interview-mobile" class="" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-interview-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training/teacher-training-interview"><span class="menu-title">Teacher training interviews</span></a></li>
<li id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-mobile" class="" data-child-menu-id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training/subject-knowledge-enhancement"><span class="menu-title">Subject knowledge enhancement (SKE)</span></a></li>
<li id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-mobile" class="" data-child-menu-id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training/if-your-application-is-unsuccessful"><span class="menu-title">If your application is unsuccessful</span></a></li>
<li class="view-all " id="menu-view-all-how-to-apply-for-teacher-training-mobile" data-direct-link="true"><a class="menu-link link link--black" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/how-to-apply-for-teacher-training"><span class="menu-title">View all in How to apply</span></a></li>
</ol></div>
</li>
      <li id="non-uk-teachers-mobile" class="" data-child-menu-id="non-uk-teachers-categories-mobile" data-direct-link="false">
<a class="menu-link link link--black link--no-underline " role="menuitem" aria-expanded="false" aria-controls="non-uk-teachers-categories-mobile" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers"><span class="menu-title">Non-UK citizens</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></a><div class="break" aria-hidden="true"></div>
<div class="desktop-level2-wrapper"><ol class="category-links-list hidden-menu" id="non-uk-teachers-categories-mobile" role="menu">
<li id="non-uk-teachers-if-you-want-to-train-to-teach-mobile" class="" data-child-menu-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">If you want to train to teach</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile">
<li id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-mobile" class="" data-child-menu-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers/train-to-teach-in-england-as-an-international-student"><span class="menu-title">Train to teach in England as a non-UK citizen</span></a></li>
<li id="non-uk-teachers-non-uk-qualifications-mobile" class="" data-child-menu-id="non-uk-teachers-non-uk-qualifications-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers/non-uk-qualifications"><span class="menu-title">Qualifications you will need to train to teach in England</span></a></li>
<li id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-mobile" class="" data-child-menu-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers/fees-and-funding-for-non-uk-trainees"><span class="menu-title">Fees and financial support for non-UK trainee teachers</span></a></li>
<li id="non-uk-teachers-visas-for-non-uk-trainees-mobile" class="" data-child-menu-id="non-uk-teachers-visas-for-non-uk-trainees-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers/visas-for-non-uk-trainees"><span class="menu-title">Visas for non-UK trainee teachers</span></a></li>
</ol></div>
</li>
<li id="non-uk-teachers-if-you-re-already-a-teacher-mobile" class="" data-child-menu-id="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">If you're already a teacher</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile">
<li id="non-uk-teachers-teach-in-england-if-you-trained-overseas-mobile" class="" data-child-menu-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers/teach-in-england-if-you-trained-overseas"><span class="menu-title">Teach in England as a non-UK qualified teacher</span></a></li>
<li id="non-uk-teachers-get-an-international-relocation-payment-mobile" class="" data-child-menu-id="non-uk-teachers-get-an-international-relocation-payment-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers/get-an-international-relocation-payment"><span class="menu-title">Get an international relocation payment</span></a></li>
<li id="non-uk-teachers-visas-for-non-uk-teachers-mobile" class="" data-child-menu-id="non-uk-teachers-visas-for-non-uk-teachers-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers/visas-for-non-uk-teachers"><span class="menu-title">Visas for non-UK teachers</span></a></li>
</ol></div>
</li>
<li id="non-uk-teachers-if-you-re-outside-the-uk-mobile" class="" data-child-menu-id="non-uk-teachers-if-you-re-outside-the-uk-pages-mobile" data-direct-link="false">
<button type="button" class="menu-link link link--black link--no-underline link--underline-on-hover btn-as-link" role="menuitem" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-outside-the-uk-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick"><span class="menu-title">If you're outside the UK</span><span class="nav-icon nav-icon__contracted" aria-hidden="true"></span></button><div class="break" aria-hidden="true"></div>
<div class="desktop-level3-wrapper"><ol class="page-links-list hidden-menu" role="menu" id="non-uk-teachers-if-you-re-outside-the-uk-pages-mobile"><li id="non-uk-teachers-international-qualified-teacher-status-mobile" class="" data-child-menu-id="non-uk-teachers-international-qualified-teacher-status-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline link--underline-on-hover" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers/international-qualified-teacher-status"><span class="menu-title">Get international qualified teacher status (iQTS)</span></a></li></ol></div>
</li>
<li class="view-all " id="menu-view-all-non-uk-teachers-mobile" data-direct-link="true"><a class="menu-link link link--black" role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/non-uk-teachers"><span class="menu-title">View all in Non-UK citizens</span></a></li>
</ol></div>
</li>
      <li id="help-and-support-mobile" class="" data-child-menu-id="help-and-support-categories-mobile" data-direct-link="true"><a class="menu-link link link--black link--no-underline " role="menuitem" data-action="keydown.enter->navigation#handleNavMenuClick" href="/help-and-support"><span class="menu-title">Get help and support</span></a></li>
</ol></nav>
  <div id="dropdown-background" aria-hidden="true"></div>
</header>
`;

    const application = Application.start();
    const mockGtag = () => { window.gtag = jest.fn(); };
    application.register('navigation', NavigationController);

    beforeEach(() => {
      mockGtag();
    });

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
      const primaryLink = document.querySelector('#train-to-be-a-teacher-mobile > a');
      const icon = document.querySelector('#train-to-be-a-teacher-mobile > a > span.nav-icon');
      const menu = document.getElementById('train-to-be-a-teacher-categories-mobile');

      expect(icon.classList).toContain('nav-icon__contracted');
      expect(menu.classList).toContain('hidden-menu');

      primaryLink.click();

      expect(icon.classList).toContain('nav-icon__expanded');
      expect(menu.classList).not.toContain('hidden-menu');

      primaryLink.click();

      expect(icon.classList).toContain('nav-icon__contracted');
      expect(menu.classList).toContain('hidden-menu');
    });

    it('toggles the menu when the user presses enter on the menu button', () => {
      const menuButton = document.getElementById('menu-toggle');
      const primaryNavigation = document.getElementById('primary-navigation');
      const enterEvent = new KeyboardEvent('keydown', { key: 'enter' });

      expect(menuButton.ariaExpanded).not.toEqual('true');
      expect(primaryNavigation.classList).toContain('hidden-mobile');

      menuButton.focus();
      menuButton.dispatchEvent(enterEvent);

      expect(menuButton.ariaExpanded).toEqual('true');
      expect(primaryNavigation.classList).not.toContain('hidden-mobile');
    });

    it('toggles the dropdown when the user presses enter on a menu item', () => {
      const trainToBeATeacher = document.querySelector('#train-to-be-a-teacher-mobile .menu-link');
      const trainToBeATeacherSubMenu = document.getElementById('train-to-be-a-teacher-categories-mobile');
      const enterEvent = new KeyboardEvent('keydown', { key: 'enter' });

      expect(trainToBeATeacherSubMenu.classList).toContain('hidden-menu');

      trainToBeATeacher.focus();
      trainToBeATeacher.dispatchEvent(enterEvent);

      expect(trainToBeATeacherSubMenu.classList).not.toContain('hidden-menu');
    });
  });
});
