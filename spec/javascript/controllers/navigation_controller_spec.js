import { Application } from '@hotwired/stimulus';
import NavigationController from 'navigation_controller.js';

describe('NavigationController', () => {
  describe('opening and closing the nav menu', () => {
    document.body.innerHTML = `
<header class="limit-content-width" data-controller="navigation" data-module="govuk-header">
	<div class="menu-button" id="mobile-navigation-menu-button">
		<a class="menu-button__button hidden-when-js-enabled" href="/browse">
			<span class="menu-button__text">Menu</span>
		</a>
		<button class="menu-button__button hidden-when-js-disabled" id="menu-toggle" aria-expanded="false" aria-controls="primary-navigation" data-action="click->navigation#toggleNav" data-navigation-target="menu">
			<span class="menu-button__text">Menu</span>
			<span class="menu-button__icon"></span>
		</button>
	</div>
	<!-- mobile navigation -->
	<nav id="primary-navigation" class="hidden-mobile" data-navigation-target="nav" data-action="click->navigation#handleNavMenuClick keydown.enter->navigation#handleNavMenuClick" aria-label="Primary navigation" role="navigation">
		<ol class="primary" data-navigation-target="primary">
			<li id="is-teaching-right-for-me-mobile" class="" data-corresponding-id="is-teaching-right-for-me-desktop" data-child-menu-id="is-teaching-right-for-me-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-categories-desktop" data-direct-link="false" data-toggle-secondary-navigation="true">
				<a class="menu-link link link--black link--no-underline" aria-expanded="false" aria-controls="is-teaching-right-for-me-categories-mobile is-teaching-right-for-me-categories-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me">
					<span class="menu-title">Is teaching right for me?</span>
					<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
				</a>
				<div class="break" aria-hidden="true"></div>
				<ol class="category-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-categories-mobile">
					<li id="is-teaching-right-for-me-pay-and-benefits-mobile" class="" data-corresponding-id="is-teaching-right-for-me-pay-and-benefits-desktop" data-child-menu-id="is-teaching-right-for-me-pay-and-benefits-pages-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-pay-and-benefits-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-pay-and-benefits-pages-mobile is-teaching-right-for-me-pay-and-benefits-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Pay and benefits</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-pay-and-benefits-pages-mobile">
							<li id="is-teaching-right-for-me-teacher-pay-and-benefits-mobile" class="" data-corresponding-id="is-teaching-right-for-me-teacher-pay-and-benefits-desktop" data-child-menu-id="is-teaching-right-for-me-teacher-pay-and-benefits-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-teacher-pay-and-benefits-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/teacher-pay-and-benefits">
									<span class="menu-title">How much do teachers get paid?</span>
								</a>
							</li>
							<li id="is-teaching-right-for-me-career-progression-mobile" class="" data-corresponding-id="is-teaching-right-for-me-career-progression-desktop" data-child-menu-id="is-teaching-right-for-me-career-progression-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-career-progression-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/career-progression">
									<span class="menu-title">How can I move up the career ladder in teaching?</span>
								</a>
							</li>
							<li id="is-teaching-right-for-me-what-pension-does-a-teacher-get-mobile" class="" data-corresponding-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-desktop" data-child-menu-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/what-pension-does-a-teacher-get">
									<span class="menu-title">What pension does a teacher get?</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="is-teaching-right-for-me-qualifications-and-experience-mobile" class="" data-corresponding-id="is-teaching-right-for-me-qualifications-and-experience-desktop" data-child-menu-id="is-teaching-right-for-me-qualifications-and-experience-pages-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-qualifications-and-experience-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-qualifications-and-experience-pages-mobile is-teaching-right-for-me-qualifications-and-experience-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Qualifications and experience</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-qualifications-and-experience-pages-mobile">
							<li id="is-teaching-right-for-me-qualifications-you-need-to-teach-mobile" class="" data-corresponding-id="is-teaching-right-for-me-qualifications-you-need-to-teach-desktop" data-child-menu-id="is-teaching-right-for-me-qualifications-you-need-to-teach-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-qualifications-you-need-to-teach-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/qualifications-you-need-to-teach">
									<span class="menu-title">What qualifications do I need to be a teacher?</span>
								</a>
							</li>
							<li id="is-teaching-right-for-me-if-you-want-to-change-career-mobile" class="" data-corresponding-id="is-teaching-right-for-me-if-you-want-to-change-career-desktop" data-child-menu-id="is-teaching-right-for-me-if-you-want-to-change-career-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-if-you-want-to-change-career-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/if-you-want-to-change-career">
									<span class="menu-title">How do I change to a career in teaching?</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="is-teaching-right-for-me-who-to-teach-mobile" class="" data-corresponding-id="is-teaching-right-for-me-who-to-teach-desktop" data-child-menu-id="is-teaching-right-for-me-who-to-teach-pages-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-who-to-teach-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-who-to-teach-pages-mobile is-teaching-right-for-me-who-to-teach-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Who to teach</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-who-to-teach-pages-mobile">
							<li id="is-teaching-right-for-me-who-do-you-want-to-teach-mobile" class="" data-corresponding-id="is-teaching-right-for-me-who-do-you-want-to-teach-desktop" data-child-menu-id="is-teaching-right-for-me-who-do-you-want-to-teach-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-who-do-you-want-to-teach-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/who-do-you-want-to-teach">
									<span class="menu-title">Which age group should I teach?</span>
								</a>
							</li>
							<li id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-mobile" class="" data-corresponding-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-desktop" data-child-menu-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/teach-disabled-pupils-and-pupils-with-special-educational-needs">
									<span class="menu-title">How can I teach children with special educational needs?</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="is-teaching-right-for-me-what-to-teach-mobile" class="" data-corresponding-id="is-teaching-right-for-me-what-to-teach-desktop" data-child-menu-id="is-teaching-right-for-me-what-to-teach-pages-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-what-to-teach-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-what-to-teach-pages-mobile is-teaching-right-for-me-what-to-teach-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">What to teach</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-what-to-teach-pages-mobile">
							<li id="is-teaching-right-for-me-computing-mobile" class="" data-corresponding-id="is-teaching-right-for-me-computing-desktop" data-child-menu-id="is-teaching-right-for-me-computing-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-computing-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/computing">
									<span class="menu-title">Computing</span>
								</a>
							</li>
							<li id="is-teaching-right-for-me-maths-mobile" class="" data-corresponding-id="is-teaching-right-for-me-maths-desktop" data-child-menu-id="is-teaching-right-for-me-maths-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-maths-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/maths">
									<span class="menu-title">Maths</span>
								</a>
							</li>
							<li id="is-teaching-right-for-me-physics-mobile" class="" data-corresponding-id="is-teaching-right-for-me-physics-desktop" data-child-menu-id="is-teaching-right-for-me-physics-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-physics-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/physics">
									<span class="menu-title">Physics</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="is-teaching-right-for-me-school-experience-mobile" class="" data-corresponding-id="is-teaching-right-for-me-school-experience-desktop" data-child-menu-id="is-teaching-right-for-me-school-experience-pages-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-school-experience-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-school-experience-pages-mobile is-teaching-right-for-me-school-experience-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">School experience</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="is-teaching-right-for-me-school-experience-pages-mobile">
							<li id="is-teaching-right-for-me-get-school-experience-mobile" class="" data-corresponding-id="is-teaching-right-for-me-get-school-experience-desktop" data-child-menu-id="is-teaching-right-for-me-get-school-experience-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-get-school-experience-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/get-school-experience">
									<span class="menu-title">How do I get experience in a school?</span>
								</a>
							</li>
							<li id="is-teaching-right-for-me-teaching-internship-providers-mobile" class="" data-corresponding-id="is-teaching-right-for-me-teaching-internship-providers-desktop" data-child-menu-id="is-teaching-right-for-me-teaching-internship-providers-categories-mobile" data-corresponding-child-menu-id="is-teaching-right-for-me-teaching-internship-providers-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/teaching-internships">
									<span class="menu-title">Can I do a teaching internship?</span>
								</a>
							</li>
						</ol>
					</li>
					<li class="view-all " id="menu-view-all-is-teaching-right-for-me-mobile" data-corresponding-id="menu-view-all-is-teaching-right-for-me-desktop" data-direct-link="true">
						<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me">
							<span class="menu-title">View all in Is teaching right for me?</span>
						</a>
					</li>
				</ol>
			</li>
			<li id="steps-to-become-a-teacher-mobile" class="" data-corresponding-id="steps-to-become-a-teacher-desktop" data-child-menu-id="steps-to-become-a-teacher-categories-mobile" data-corresponding-child-menu-id="steps-to-become-a-teacher-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
				<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/steps-to-become-a-teacher">
					<span class="menu-title">How to become a teacher</span>
				</a>
			</li>
			<li id="train-to-be-a-teacher-mobile" class="" data-corresponding-id="train-to-be-a-teacher-desktop" data-child-menu-id="train-to-be-a-teacher-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-categories-desktop" data-direct-link="false" data-toggle-secondary-navigation="true">
				<a class="menu-link link link--black link--no-underline" aria-expanded="false" aria-controls="train-to-be-a-teacher-categories-mobile train-to-be-a-teacher-categories-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher">
					<span class="menu-title">Train to be a teacher</span>
					<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
				</a>
				<div class="break" aria-hidden="true"></div>
				<ol class="category-links-list hidden-menu hidden-desktop" id="train-to-be-a-teacher-categories-mobile">
					<li id="train-to-be-a-teacher-postgraduate-teacher-training-mobile" class="" data-corresponding-id="train-to-be-a-teacher-postgraduate-teacher-training-desktop" data-child-menu-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Postgraduate teacher training</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile">
							<li id="train-to-be-a-teacher-if-you-have-a-degree-mobile" class="" data-corresponding-id="train-to-be-a-teacher-if-you-have-a-degree-desktop" data-child-menu-id="train-to-be-a-teacher-if-you-have-a-degree-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-if-you-have-a-degree-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/if-you-have-a-degree">
									<span class="menu-title">If you have or are studying for a degree</span>
								</a>
							</li>
							<li id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-mobile" class="" data-corresponding-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-desktop" data-child-menu-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/how-to-choose-your-teacher-training-course">
									<span class="menu-title">How to choose your course</span>
								</a>
							</li>
							<li id="train-to-be-a-teacher-initial-teacher-training-mobile" class="" data-corresponding-id="train-to-be-a-teacher-initial-teacher-training-desktop" data-child-menu-id="train-to-be-a-teacher-initial-teacher-training-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-initial-teacher-training-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/initial-teacher-training">
									<span class="menu-title">What to expect in teacher training</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="train-to-be-a-teacher-qualifications-you-can-get-mobile" class="" data-corresponding-id="train-to-be-a-teacher-qualifications-you-can-get-desktop" data-child-menu-id="train-to-be-a-teacher-qualifications-you-can-get-pages-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-qualifications-you-can-get-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="train-to-be-a-teacher-qualifications-you-can-get-pages-mobile train-to-be-a-teacher-qualifications-you-can-get-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Qualifications you can get</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="train-to-be-a-teacher-qualifications-you-can-get-pages-mobile">
							<li id="train-to-be-a-teacher-what-is-qts-mobile" class="" data-corresponding-id="train-to-be-a-teacher-what-is-qts-desktop" data-child-menu-id="train-to-be-a-teacher-what-is-qts-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-what-is-qts-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/what-is-qts">
									<span class="menu-title">Qualified teacher status (QTS)</span>
								</a>
							</li>
							<li id="train-to-be-a-teacher-what-is-a-pgce-mobile" class="" data-corresponding-id="train-to-be-a-teacher-what-is-a-pgce-desktop" data-child-menu-id="train-to-be-a-teacher-what-is-a-pgce-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-what-is-a-pgce-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/what-is-a-pgce">
									<span class="menu-title">Postgraduate certificate in education (PGCE)</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="train-to-be-a-teacher-other-routes-into-teaching-mobile" class="" data-corresponding-id="train-to-be-a-teacher-other-routes-into-teaching-desktop" data-child-menu-id="train-to-be-a-teacher-other-routes-into-teaching-pages-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-other-routes-into-teaching-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="train-to-be-a-teacher-other-routes-into-teaching-pages-mobile train-to-be-a-teacher-other-routes-into-teaching-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Other routes into teaching</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="train-to-be-a-teacher-other-routes-into-teaching-pages-mobile">
							<li id="train-to-be-a-teacher-if-you-dont-have-a-degree-mobile" class="" data-corresponding-id="train-to-be-a-teacher-if-you-dont-have-a-degree-desktop" data-child-menu-id="train-to-be-a-teacher-if-you-dont-have-a-degree-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-if-you-dont-have-a-degree-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/if-you-dont-have-a-degree">
									<span class="menu-title">If you do not have a degree</span>
								</a>
							</li>
							<li id="train-to-be-a-teacher-assessment-only-route-to-qts-mobile" class="" data-corresponding-id="train-to-be-a-teacher-assessment-only-route-to-qts-desktop" data-child-menu-id="train-to-be-a-teacher-assessment-only-route-to-qts-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-assessment-only-route-to-qts-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/assessment-only-route-to-qts">
									<span class="menu-title">If you’ve worked as an unqualified teacher</span>
								</a>
							</li>
							<li id="train-to-be-a-teacher-teacher-degree-apprenticeships-mobile" class="" data-corresponding-id="train-to-be-a-teacher-teacher-degree-apprenticeships-desktop" data-child-menu-id="train-to-be-a-teacher-teacher-degree-apprenticeships-categories-mobile" data-corresponding-child-menu-id="train-to-be-a-teacher-teacher-degree-apprenticeships-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/teacher-degree-apprenticeships">
									<span class="menu-title">If you want to do a teaching apprenticeship</span>
								</a>
							</li>
						</ol>
					</li>
					<li class="view-all " id="menu-view-all-train-to-be-a-teacher-mobile" data-corresponding-id="menu-view-all-train-to-be-a-teacher-desktop" data-direct-link="true">
						<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher">
							<span class="menu-title">View all in Train to be a teacher</span>
						</a>
					</li>
				</ol>
			</li>
			<li id="funding-and-support-mobile" class="" data-corresponding-id="funding-and-support-desktop" data-child-menu-id="funding-and-support-categories-mobile" data-corresponding-child-menu-id="funding-and-support-categories-desktop" data-direct-link="false" data-toggle-secondary-navigation="true">
				<a class="menu-link link link--black link--no-underline" aria-expanded="false" aria-controls="funding-and-support-categories-mobile funding-and-support-categories-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support">
					<span class="menu-title">Fund your training</span>
					<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
				</a>
				<div class="break" aria-hidden="true"></div>
				<ol class="category-links-list hidden-menu hidden-desktop" id="funding-and-support-categories-mobile">
					<li id="funding-and-support-courses-with-fees-mobile" class="" data-corresponding-id="funding-and-support-courses-with-fees-desktop" data-child-menu-id="funding-and-support-courses-with-fees-pages-mobile" data-corresponding-child-menu-id="funding-and-support-courses-with-fees-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="funding-and-support-courses-with-fees-pages-mobile funding-and-support-courses-with-fees-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Courses with fees</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="funding-and-support-courses-with-fees-pages-mobile">
							<li id="funding-and-support-tuition-fees-mobile" class="" data-corresponding-id="funding-and-support-tuition-fees-desktop" data-child-menu-id="funding-and-support-tuition-fees-categories-mobile" data-corresponding-child-menu-id="funding-and-support-tuition-fees-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/tuition-fees">
									<span class="menu-title">Tuition fees</span>
								</a>
							</li>
							<li id="funding-and-support-tuition-fee-and-maintenance-loans-mobile" class="" data-corresponding-id="funding-and-support-tuition-fee-and-maintenance-loans-desktop" data-child-menu-id="funding-and-support-tuition-fee-and-maintenance-loans-categories-mobile" data-corresponding-child-menu-id="funding-and-support-tuition-fee-and-maintenance-loans-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/tuition-fee-and-maintenance-loans">
									<span class="menu-title">Student finance for teacher training</span>
								</a>
							</li>
							<li id="funding-and-support-scholarships-and-bursaries-mobile" class="" data-corresponding-id="funding-and-support-scholarships-and-bursaries-desktop" data-child-menu-id="funding-and-support-scholarships-and-bursaries-categories-mobile" data-corresponding-child-menu-id="funding-and-support-scholarships-and-bursaries-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/scholarships-and-bursaries">
									<span class="menu-title">Bursaries and scholarships</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="funding-and-support-courses-with-a-salary-mobile" class="" data-corresponding-id="funding-and-support-courses-with-a-salary-desktop" data-child-menu-id="funding-and-support-courses-with-a-salary-pages-mobile" data-corresponding-child-menu-id="funding-and-support-courses-with-a-salary-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="funding-and-support-courses-with-a-salary-pages-mobile funding-and-support-courses-with-a-salary-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Courses with a salary</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="funding-and-support-courses-with-a-salary-pages-mobile">
							<li id="funding-and-support-salaried-teacher-training-mobile" class="" data-corresponding-id="funding-and-support-salaried-teacher-training-desktop" data-child-menu-id="funding-and-support-salaried-teacher-training-categories-mobile" data-corresponding-child-menu-id="funding-and-support-salaried-teacher-training-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/salaried-teacher-training">
									<span class="menu-title">Salaried teacher training</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="funding-and-support-extra-support-mobile" class="" data-corresponding-id="funding-and-support-extra-support-desktop" data-child-menu-id="funding-and-support-extra-support-pages-mobile" data-corresponding-child-menu-id="funding-and-support-extra-support-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="funding-and-support-extra-support-pages-mobile funding-and-support-extra-support-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Extra support</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="funding-and-support-extra-support-pages-mobile">
							<li id="funding-and-support-if-youre-disabled-mobile" class="" data-corresponding-id="funding-and-support-if-youre-disabled-desktop" data-child-menu-id="funding-and-support-if-youre-disabled-categories-mobile" data-corresponding-child-menu-id="funding-and-support-if-youre-disabled-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/if-youre-disabled">
									<span class="menu-title">Funding and support if you're disabled</span>
								</a>
							</li>
							<li id="funding-and-support-if-youre-a-parent-or-carer-mobile" class="" data-corresponding-id="funding-and-support-if-youre-a-parent-or-carer-desktop" data-child-menu-id="funding-and-support-if-youre-a-parent-or-carer-categories-mobile" data-corresponding-child-menu-id="funding-and-support-if-youre-a-parent-or-carer-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/if-youre-a-parent-or-carer">
									<span class="menu-title">Funding and support if you're a parent or carer</span>
								</a>
							</li>
							<li id="funding-and-support-if-youre-a-veteran-mobile" class="" data-corresponding-id="funding-and-support-if-youre-a-veteran-desktop" data-child-menu-id="funding-and-support-if-youre-a-veteran-categories-mobile" data-corresponding-child-menu-id="funding-and-support-if-youre-a-veteran-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/if-youre-a-veteran">
									<span class="menu-title">Funding and support if you're a veteran</span>
								</a>
							</li>
						</ol>
					</li>
					<li class="view-all " id="menu-view-all-funding-and-support-mobile" data-corresponding-id="menu-view-all-funding-and-support-desktop" data-direct-link="true">
						<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support">
							<span class="menu-title">View all in Fund your training</span>
						</a>
					</li>
				</ol>
			</li>
			<li id="how-to-apply-for-teacher-training-mobile" class="" data-corresponding-id="how-to-apply-for-teacher-training-desktop" data-child-menu-id="how-to-apply-for-teacher-training-categories-mobile" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-categories-desktop" data-direct-link="false" data-toggle-secondary-navigation="true">
				<a class="menu-link link link--black link--no-underline" aria-expanded="false" aria-controls="how-to-apply-for-teacher-training-categories-mobile how-to-apply-for-teacher-training-categories-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training">
					<span class="menu-title">How to apply</span>
					<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
				</a>
				<div class="break" aria-hidden="true"></div>
				<ol class="category-links-list hidden-menu hidden-desktop" id="how-to-apply-for-teacher-training-categories-mobile">
					<li id="how-to-apply-for-teacher-training-teacher-training-application-mobile" class="" data-corresponding-id="how-to-apply-for-teacher-training-teacher-training-application-desktop" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-application-categories-mobile" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-teacher-training-application-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
						<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/teacher-training-application">
							<span class="menu-title">Teacher training application</span>
						</a>
					</li>
					<li id="how-to-apply-for-teacher-training-teacher-training-personal-statement-mobile" class="" data-corresponding-id="how-to-apply-for-teacher-training-teacher-training-personal-statement-desktop" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-personal-statement-categories-mobile" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-teacher-training-personal-statement-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
						<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/teacher-training-personal-statement">
							<span class="menu-title">Teacher training personal statement</span>
						</a>
					</li>
					<li id="how-to-apply-for-teacher-training-teacher-training-references-mobile" class="" data-corresponding-id="how-to-apply-for-teacher-training-teacher-training-references-desktop" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-references-categories-mobile" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-teacher-training-references-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
						<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/teacher-training-references">
							<span class="menu-title">Teacher training references</span>
						</a>
					</li>
					<li id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-mobile" class="" data-corresponding-id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-desktop" data-child-menu-id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-categories-mobile" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
						<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/when-to-apply-for-teacher-training">
							<span class="menu-title">When to apply for teacher training</span>
						</a>
					</li>
					<li id="how-to-apply-for-teacher-training-teacher-training-interview-mobile" class="" data-corresponding-id="how-to-apply-for-teacher-training-teacher-training-interview-desktop" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-interview-categories-mobile" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-teacher-training-interview-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
						<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/teacher-training-interview">
							<span class="menu-title">Teacher training interviews</span>
						</a>
					</li>
					<li id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-mobile" class="" data-corresponding-id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-desktop" data-child-menu-id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-categories-mobile" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
						<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/subject-knowledge-enhancement">
							<span class="menu-title">Subject knowledge enhancement (SKE)</span>
						</a>
					</li>
					<li id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-mobile" class="" data-corresponding-id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-desktop" data-child-menu-id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-categories-mobile" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
						<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/if-your-application-is-unsuccessful">
							<span class="menu-title">If your application is unsuccessful</span>
						</a>
					</li>
					<li class="view-all " id="menu-view-all-how-to-apply-for-teacher-training-mobile" data-corresponding-id="menu-view-all-how-to-apply-for-teacher-training-desktop" data-direct-link="true">
						<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training">
							<span class="menu-title">View all in How to apply</span>
						</a>
					</li>
				</ol>
			</li>
			<li id="non-uk-teachers-mobile" class="" data-corresponding-id="non-uk-teachers-desktop" data-child-menu-id="non-uk-teachers-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-categories-desktop" data-direct-link="false" data-toggle-secondary-navigation="true">
				<a class="menu-link link link--black link--no-underline" aria-expanded="false" aria-controls="non-uk-teachers-categories-mobile non-uk-teachers-categories-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers">
					<span class="menu-title">Non-UK citizens</span>
					<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
				</a>
				<div class="break" aria-hidden="true"></div>
				<ol class="category-links-list hidden-menu hidden-desktop" id="non-uk-teachers-categories-mobile">
					<li id="non-uk-teachers-if-you-want-to-train-to-teach-mobile" class="" data-corresponding-id="non-uk-teachers-if-you-want-to-train-to-teach-desktop" data-child-menu-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile" data-corresponding-child-menu-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">If you want to train to teach</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile">
							<li id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-mobile" class="" data-corresponding-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-desktop" data-child-menu-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/train-to-teach-in-england-as-an-international-student">
									<span class="menu-title">Train to teach in England as a non-UK citizen</span>
								</a>
							</li>
							<li id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-mobile" class="" data-corresponding-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-desktop" data-child-menu-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/fees-and-funding-for-non-uk-trainees">
									<span class="menu-title">Fees and financial support for non-UK trainee teachers</span>
								</a>
							</li>
							<li id="non-uk-teachers-non-uk-qualifications-mobile" class="" data-corresponding-id="non-uk-teachers-non-uk-qualifications-desktop" data-child-menu-id="non-uk-teachers-non-uk-qualifications-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-non-uk-qualifications-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/non-uk-qualifications">
									<span class="menu-title">Qualifications you'll need to train to teach in England</span>
								</a>
							</li>
							<li id="non-uk-teachers-visas-for-non-uk-trainees-mobile" class="" data-corresponding-id="non-uk-teachers-visas-for-non-uk-trainees-desktop" data-child-menu-id="non-uk-teachers-visas-for-non-uk-trainees-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-visas-for-non-uk-trainees-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/visas-for-non-uk-trainees">
									<span class="menu-title">Apply for your visa to train to teach</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="non-uk-teachers-if-you-re-already-a-teacher-mobile" class="" data-corresponding-id="non-uk-teachers-if-you-re-already-a-teacher-desktop" data-child-menu-id="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile" data-corresponding-child-menu-id="non-uk-teachers-if-you-re-already-a-teacher-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile non-uk-teachers-if-you-re-already-a-teacher-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">If you're already a teacher</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile">
							<li id="non-uk-teachers-teach-in-england-if-you-trained-overseas-mobile" class="" data-corresponding-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-desktop" data-child-menu-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/teach-in-england-if-you-trained-overseas">
									<span class="menu-title">Teach in England as a non-UK qualified teacher</span>
								</a>
							</li>
							<li id="non-uk-teachers-get-an-international-relocation-payment-mobile" class="" data-corresponding-id="non-uk-teachers-get-an-international-relocation-payment-desktop" data-child-menu-id="non-uk-teachers-get-an-international-relocation-payment-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-get-an-international-relocation-payment-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/get-an-international-relocation-payment">
									<span class="menu-title">Get an international relocation payment</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="non-uk-teachers-get-international-qualified-teacher-status-iqts-mobile" class="" data-corresponding-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-desktop" data-child-menu-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile" data-corresponding-child-menu-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">Get international qualified teacher status (iQTS)</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile">
							<li id="non-uk-teachers-international-qualified-teacher-status-mobile" class="" data-corresponding-id="non-uk-teachers-international-qualified-teacher-status-desktop" data-child-menu-id="non-uk-teachers-international-qualified-teacher-status-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-international-qualified-teacher-status-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/international-qualified-teacher-status">
									<span class="menu-title">Gain the equivalent of English QTS, from outside the UK</span>
								</a>
							</li>
						</ol>
					</li>
					<li id="non-uk-teachers-if-you-re-from-ukraine-mobile" class="" data-corresponding-id="non-uk-teachers-if-you-re-from-ukraine-desktop" data-child-menu-id="non-uk-teachers-if-you-re-from-ukraine-pages-mobile" data-corresponding-child-menu-id="non-uk-teachers-if-you-re-from-ukraine-pages-desktop" data-direct-link="false">
						<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-from-ukraine-pages-mobile non-uk-teachers-if-you-re-from-ukraine-pages-desktop" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
							<span class="menu-title">If you're from Ukraine</span>
							<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
						</button>
						<div class="break" aria-hidden="true"></div>
						<ol class="page-links-list hidden-menu hidden-desktop" id="non-uk-teachers-if-you-re-from-ukraine-pages-mobile">
							<li id="non-uk-teachers-ukraine-mobile" class="" data-corresponding-id="non-uk-teachers-ukraine-desktop" data-child-menu-id="non-uk-teachers-ukraine-categories-mobile" data-corresponding-child-menu-id="non-uk-teachers-ukraine-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
								<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/ukraine">
									<span class="menu-title">Ukrainian teachers and trainees coming to the UK</span>
								</a>
							</li>
						</ol>
					</li>
					<li class="view-all " id="menu-view-all-non-uk-teachers-mobile" data-corresponding-id="menu-view-all-non-uk-teachers-desktop" data-direct-link="true">
						<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers">
							<span class="menu-title">View all in Non-UK citizens</span>
						</a>
					</li>
				</ol>
			</li>
			<li id="help-and-support-mobile" class="" data-corresponding-id="help-and-support-desktop" data-child-menu-id="help-and-support-categories-mobile" data-corresponding-child-menu-id="help-and-support-categories-desktop" data-direct-link="true" data-toggle-secondary-navigation="false">
				<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/help-and-support">
					<span class="menu-title">Get help and support</span>
				</a>
			</li>
		</ol>
	</nav>
	<!-- desktop dropdown navigation -->
	<div id="secondary-navigation" class="desktop-menu-container hidden-mobile" data-navigation-target="desktop" data-action="click->navigation#handleNavMenuClick keydown.enter->navigation#handleNavMenuClick" aria-label="Secondary navigation" role="navigation">
		<div class="category-links">
			<ol class="category-links-list hidden-menu" id="is-teaching-right-for-me-categories-desktop">
				<li id="is-teaching-right-for-me-pay-and-benefits-desktop" class="" data-corresponding-id="is-teaching-right-for-me-pay-and-benefits-mobile" data-child-menu-id="is-teaching-right-for-me-pay-and-benefits-pages-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-pay-and-benefits-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-pay-and-benefits-pages-desktop is-teaching-right-for-me-pay-and-benefits-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Pay and benefits</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="is-teaching-right-for-me-qualifications-and-experience-desktop" class="" data-corresponding-id="is-teaching-right-for-me-qualifications-and-experience-mobile" data-child-menu-id="is-teaching-right-for-me-qualifications-and-experience-pages-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-qualifications-and-experience-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-qualifications-and-experience-pages-desktop is-teaching-right-for-me-qualifications-and-experience-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Qualifications and experience</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="is-teaching-right-for-me-who-to-teach-desktop" class="" data-corresponding-id="is-teaching-right-for-me-who-to-teach-mobile" data-child-menu-id="is-teaching-right-for-me-who-to-teach-pages-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-who-to-teach-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-who-to-teach-pages-desktop is-teaching-right-for-me-who-to-teach-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Who to teach</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="is-teaching-right-for-me-what-to-teach-desktop" class="" data-corresponding-id="is-teaching-right-for-me-what-to-teach-mobile" data-child-menu-id="is-teaching-right-for-me-what-to-teach-pages-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-what-to-teach-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-what-to-teach-pages-desktop is-teaching-right-for-me-what-to-teach-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">What to teach</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="is-teaching-right-for-me-school-experience-desktop" class="" data-corresponding-id="is-teaching-right-for-me-school-experience-mobile" data-child-menu-id="is-teaching-right-for-me-school-experience-pages-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-school-experience-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="is-teaching-right-for-me-school-experience-pages-desktop is-teaching-right-for-me-school-experience-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">School experience</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li class="view-all " id="menu-view-all-is-teaching-right-for-me-desktop" data-corresponding-id="menu-view-all-is-teaching-right-for-me-mobile" data-direct-link="true">
					<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me">
						<span class="menu-title">View all in Is teaching right for me?</span>
					</a>
				</li>
			</ol>
			<ol class="category-links-list hidden-menu" id="train-to-be-a-teacher-categories-desktop">
				<li id="train-to-be-a-teacher-postgraduate-teacher-training-desktop" class="" data-corresponding-id="train-to-be-a-teacher-postgraduate-teacher-training-mobile" data-child-menu-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop train-to-be-a-teacher-postgraduate-teacher-training-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Postgraduate teacher training</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="train-to-be-a-teacher-qualifications-you-can-get-desktop" class="" data-corresponding-id="train-to-be-a-teacher-qualifications-you-can-get-mobile" data-child-menu-id="train-to-be-a-teacher-qualifications-you-can-get-pages-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-qualifications-you-can-get-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="train-to-be-a-teacher-qualifications-you-can-get-pages-desktop train-to-be-a-teacher-qualifications-you-can-get-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Qualifications you can get</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="train-to-be-a-teacher-other-routes-into-teaching-desktop" class="" data-corresponding-id="train-to-be-a-teacher-other-routes-into-teaching-mobile" data-child-menu-id="train-to-be-a-teacher-other-routes-into-teaching-pages-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-other-routes-into-teaching-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="train-to-be-a-teacher-other-routes-into-teaching-pages-desktop train-to-be-a-teacher-other-routes-into-teaching-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Other routes into teaching</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li class="view-all " id="menu-view-all-train-to-be-a-teacher-desktop" data-corresponding-id="menu-view-all-train-to-be-a-teacher-mobile" data-direct-link="true">
					<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher">
						<span class="menu-title">View all in Train to be a teacher</span>
					</a>
				</li>
			</ol>
			<ol class="category-links-list hidden-menu" id="funding-and-support-categories-desktop">
				<li id="funding-and-support-courses-with-fees-desktop" class="" data-corresponding-id="funding-and-support-courses-with-fees-mobile" data-child-menu-id="funding-and-support-courses-with-fees-pages-desktop" data-corresponding-child-menu-id="funding-and-support-courses-with-fees-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="funding-and-support-courses-with-fees-pages-desktop funding-and-support-courses-with-fees-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Courses with fees</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="funding-and-support-courses-with-a-salary-desktop" class="" data-corresponding-id="funding-and-support-courses-with-a-salary-mobile" data-child-menu-id="funding-and-support-courses-with-a-salary-pages-desktop" data-corresponding-child-menu-id="funding-and-support-courses-with-a-salary-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="funding-and-support-courses-with-a-salary-pages-desktop funding-and-support-courses-with-a-salary-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Courses with a salary</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="funding-and-support-extra-support-desktop" class="" data-corresponding-id="funding-and-support-extra-support-mobile" data-child-menu-id="funding-and-support-extra-support-pages-desktop" data-corresponding-child-menu-id="funding-and-support-extra-support-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="funding-and-support-extra-support-pages-desktop funding-and-support-extra-support-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Extra support</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li class="view-all " id="menu-view-all-funding-and-support-desktop" data-corresponding-id="menu-view-all-funding-and-support-mobile" data-direct-link="true">
					<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support">
						<span class="menu-title">View all in Fund your training</span>
					</a>
				</li>
			</ol>
			<ol class="category-links-list hidden-menu" id="how-to-apply-for-teacher-training-categories-desktop">
				<li id="how-to-apply-for-teacher-training-teacher-training-application-desktop" class="" data-corresponding-id="how-to-apply-for-teacher-training-teacher-training-application-mobile" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-application-categories-desktop" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-teacher-training-application-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/teacher-training-application">
						<span class="menu-title">Teacher training application</span>
					</a>
				</li>
				<li id="how-to-apply-for-teacher-training-teacher-training-personal-statement-desktop" class="" data-corresponding-id="how-to-apply-for-teacher-training-teacher-training-personal-statement-mobile" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-personal-statement-categories-desktop" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-teacher-training-personal-statement-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/teacher-training-personal-statement">
						<span class="menu-title">Teacher training personal statement</span>
					</a>
				</li>
				<li id="how-to-apply-for-teacher-training-teacher-training-references-desktop" class="" data-corresponding-id="how-to-apply-for-teacher-training-teacher-training-references-mobile" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-references-categories-desktop" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-teacher-training-references-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/teacher-training-references">
						<span class="menu-title">Teacher training references</span>
					</a>
				</li>
				<li id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-desktop" class="" data-corresponding-id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-mobile" data-child-menu-id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-categories-desktop" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-when-to-apply-for-teacher-training-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/when-to-apply-for-teacher-training">
						<span class="menu-title">When to apply for teacher training</span>
					</a>
				</li>
				<li id="how-to-apply-for-teacher-training-teacher-training-interview-desktop" class="" data-corresponding-id="how-to-apply-for-teacher-training-teacher-training-interview-mobile" data-child-menu-id="how-to-apply-for-teacher-training-teacher-training-interview-categories-desktop" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-teacher-training-interview-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/teacher-training-interview">
						<span class="menu-title">Teacher training interviews</span>
					</a>
				</li>
				<li id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-desktop" class="" data-corresponding-id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-mobile" data-child-menu-id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-categories-desktop" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-subject-knowledge-enhancement-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/subject-knowledge-enhancement">
						<span class="menu-title">Subject knowledge enhancement (SKE)</span>
					</a>
				</li>
				<li id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-desktop" class="" data-corresponding-id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-mobile" data-child-menu-id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-categories-desktop" data-corresponding-child-menu-id="how-to-apply-for-teacher-training-if-your-application-is-unsuccessful-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training/if-your-application-is-unsuccessful">
						<span class="menu-title">If your application is unsuccessful</span>
					</a>
				</li>
				<li class="view-all " id="menu-view-all-how-to-apply-for-teacher-training-desktop" data-corresponding-id="menu-view-all-how-to-apply-for-teacher-training-mobile" data-direct-link="true">
					<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/how-to-apply-for-teacher-training">
						<span class="menu-title">View all in How to apply</span>
					</a>
				</li>
			</ol>
			<ol class="category-links-list hidden-menu" id="non-uk-teachers-categories-desktop">
				<li id="non-uk-teachers-if-you-want-to-train-to-teach-desktop" class="" data-corresponding-id="non-uk-teachers-if-you-want-to-train-to-teach-mobile" data-child-menu-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop" data-corresponding-child-menu-id="non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop non-uk-teachers-if-you-want-to-train-to-teach-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">If you want to train to teach</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="non-uk-teachers-if-you-re-already-a-teacher-desktop" class="" data-corresponding-id="non-uk-teachers-if-you-re-already-a-teacher-mobile" data-child-menu-id="non-uk-teachers-if-you-re-already-a-teacher-pages-desktop" data-corresponding-child-menu-id="non-uk-teachers-if-you-re-already-a-teacher-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-already-a-teacher-pages-desktop non-uk-teachers-if-you-re-already-a-teacher-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">If you're already a teacher</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="non-uk-teachers-get-international-qualified-teacher-status-iqts-desktop" class="" data-corresponding-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-mobile" data-child-menu-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop" data-corresponding-child-menu-id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">Get international qualified teacher status (iQTS)</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li id="non-uk-teachers-if-you-re-from-ukraine-desktop" class="" data-corresponding-id="non-uk-teachers-if-you-re-from-ukraine-mobile" data-child-menu-id="non-uk-teachers-if-you-re-from-ukraine-pages-desktop" data-corresponding-child-menu-id="non-uk-teachers-if-you-re-from-ukraine-pages-mobile" data-direct-link="false">
					<button type="button" class="menu-link link link--black link--no-underline btn-as-link" aria-expanded="false" aria-controls="non-uk-teachers-if-you-re-from-ukraine-pages-desktop non-uk-teachers-if-you-re-from-ukraine-pages-mobile" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab">
						<span class="menu-title">If you're from Ukraine</span>
						<span class="nav-icon nav-icon__contracted" aria-hidden="true"></span>
					</button>
					<div class="break" aria-hidden="true"></div>
				</li>
				<li class="view-all " id="menu-view-all-non-uk-teachers-desktop" data-corresponding-id="menu-view-all-non-uk-teachers-mobile" data-direct-link="true">
					<a class="menu-link link link--black" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers">
						<span class="menu-title">View all in Non-UK citizens</span>
					</a>
				</li>
			</ol>
		</div>
		<div class="page-links">
			<ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-pay-and-benefits-pages-desktop">
				<li id="is-teaching-right-for-me-teacher-pay-and-benefits-desktop" class="" data-corresponding-id="is-teaching-right-for-me-teacher-pay-and-benefits-mobile" data-child-menu-id="is-teaching-right-for-me-teacher-pay-and-benefits-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-teacher-pay-and-benefits-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/teacher-pay-and-benefits">
						<span class="menu-title">How much do teachers get paid?</span>
					</a>
				</li>
				<li id="is-teaching-right-for-me-career-progression-desktop" class="" data-corresponding-id="is-teaching-right-for-me-career-progression-mobile" data-child-menu-id="is-teaching-right-for-me-career-progression-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-career-progression-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/career-progression">
						<span class="menu-title">How can I move up the career ladder in teaching?</span>
					</a>
				</li>
				<li id="is-teaching-right-for-me-what-pension-does-a-teacher-get-desktop" class="" data-corresponding-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-mobile" data-child-menu-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-what-pension-does-a-teacher-get-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/what-pension-does-a-teacher-get">
						<span class="menu-title">What pension does a teacher get?</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-qualifications-and-experience-pages-desktop">
				<li id="is-teaching-right-for-me-qualifications-you-need-to-teach-desktop" class="" data-corresponding-id="is-teaching-right-for-me-qualifications-you-need-to-teach-mobile" data-child-menu-id="is-teaching-right-for-me-qualifications-you-need-to-teach-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-qualifications-you-need-to-teach-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/qualifications-you-need-to-teach">
						<span class="menu-title">What qualifications do I need to be a teacher?</span>
					</a>
				</li>
				<li id="is-teaching-right-for-me-if-you-want-to-change-career-desktop" class="" data-corresponding-id="is-teaching-right-for-me-if-you-want-to-change-career-mobile" data-child-menu-id="is-teaching-right-for-me-if-you-want-to-change-career-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-if-you-want-to-change-career-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/if-you-want-to-change-career">
						<span class="menu-title">How do I change to a career in teaching?</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-who-to-teach-pages-desktop">
				<li id="is-teaching-right-for-me-who-do-you-want-to-teach-desktop" class="" data-corresponding-id="is-teaching-right-for-me-who-do-you-want-to-teach-mobile" data-child-menu-id="is-teaching-right-for-me-who-do-you-want-to-teach-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-who-do-you-want-to-teach-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/who-do-you-want-to-teach">
						<span class="menu-title">Which age group should I teach?</span>
					</a>
				</li>
				<li id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-desktop" class="" data-corresponding-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-mobile" data-child-menu-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-teach-disabled-pupils-and-pupils-with-special-educational-needs-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/teach-disabled-pupils-and-pupils-with-special-educational-needs">
						<span class="menu-title">How can I teach children with special educational needs?</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-what-to-teach-pages-desktop">
				<li id="is-teaching-right-for-me-computing-desktop" class="" data-corresponding-id="is-teaching-right-for-me-computing-mobile" data-child-menu-id="is-teaching-right-for-me-computing-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-computing-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/computing">
						<span class="menu-title">Computing</span>
					</a>
				</li>
				<li id="is-teaching-right-for-me-maths-desktop" class="" data-corresponding-id="is-teaching-right-for-me-maths-mobile" data-child-menu-id="is-teaching-right-for-me-maths-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-maths-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/maths">
						<span class="menu-title">Maths</span>
					</a>
				</li>
				<li id="is-teaching-right-for-me-physics-desktop" class="" data-corresponding-id="is-teaching-right-for-me-physics-mobile" data-child-menu-id="is-teaching-right-for-me-physics-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-physics-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/physics">
						<span class="menu-title">Physics</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="is-teaching-right-for-me-school-experience-pages-desktop">
				<li id="is-teaching-right-for-me-get-school-experience-desktop" class="" data-corresponding-id="is-teaching-right-for-me-get-school-experience-mobile" data-child-menu-id="is-teaching-right-for-me-get-school-experience-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-get-school-experience-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/is-teaching-right-for-me/get-school-experience">
						<span class="menu-title">How do I get experience in a school?</span>
					</a>
				</li>
				<li id="is-teaching-right-for-me-teaching-internship-providers-desktop" class="" data-corresponding-id="is-teaching-right-for-me-teaching-internship-providers-mobile" data-child-menu-id="is-teaching-right-for-me-teaching-internship-providers-categories-desktop" data-corresponding-child-menu-id="is-teaching-right-for-me-teaching-internship-providers-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/teaching-internships">
						<span class="menu-title">Can I do a teaching internship?</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="train-to-be-a-teacher-postgraduate-teacher-training-pages-desktop">
				<li id="train-to-be-a-teacher-if-you-have-a-degree-desktop" class="" data-corresponding-id="train-to-be-a-teacher-if-you-have-a-degree-mobile" data-child-menu-id="train-to-be-a-teacher-if-you-have-a-degree-categories-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-if-you-have-a-degree-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/if-you-have-a-degree">
						<span class="menu-title">If you have or are studying for a degree</span>
					</a>
				</li>
				<li id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-desktop" class="" data-corresponding-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-mobile" data-child-menu-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-how-to-choose-your-teacher-training-course-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/how-to-choose-your-teacher-training-course">
						<span class="menu-title">How to choose your course</span>
					</a>
				</li>
				<li id="train-to-be-a-teacher-initial-teacher-training-desktop" class="" data-corresponding-id="train-to-be-a-teacher-initial-teacher-training-mobile" data-child-menu-id="train-to-be-a-teacher-initial-teacher-training-categories-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-initial-teacher-training-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/initial-teacher-training">
						<span class="menu-title">What to expect in teacher training</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="train-to-be-a-teacher-qualifications-you-can-get-pages-desktop">
				<li id="train-to-be-a-teacher-what-is-qts-desktop" class="" data-corresponding-id="train-to-be-a-teacher-what-is-qts-mobile" data-child-menu-id="train-to-be-a-teacher-what-is-qts-categories-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-what-is-qts-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/what-is-qts">
						<span class="menu-title">Qualified teacher status (QTS)</span>
					</a>
				</li>
				<li id="train-to-be-a-teacher-what-is-a-pgce-desktop" class="" data-corresponding-id="train-to-be-a-teacher-what-is-a-pgce-mobile" data-child-menu-id="train-to-be-a-teacher-what-is-a-pgce-categories-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-what-is-a-pgce-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/what-is-a-pgce">
						<span class="menu-title">Postgraduate certificate in education (PGCE)</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="train-to-be-a-teacher-other-routes-into-teaching-pages-desktop">
				<li id="train-to-be-a-teacher-if-you-dont-have-a-degree-desktop" class="" data-corresponding-id="train-to-be-a-teacher-if-you-dont-have-a-degree-mobile" data-child-menu-id="train-to-be-a-teacher-if-you-dont-have-a-degree-categories-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-if-you-dont-have-a-degree-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/if-you-dont-have-a-degree">
						<span class="menu-title">If you do not have a degree</span>
					</a>
				</li>
				<li id="train-to-be-a-teacher-assessment-only-route-to-qts-desktop" class="" data-corresponding-id="train-to-be-a-teacher-assessment-only-route-to-qts-mobile" data-child-menu-id="train-to-be-a-teacher-assessment-only-route-to-qts-categories-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-assessment-only-route-to-qts-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/assessment-only-route-to-qts">
						<span class="menu-title">If you’ve worked as an unqualified teacher</span>
					</a>
				</li>
				<li id="train-to-be-a-teacher-teacher-degree-apprenticeships-desktop" class="" data-corresponding-id="train-to-be-a-teacher-teacher-degree-apprenticeships-mobile" data-child-menu-id="train-to-be-a-teacher-teacher-degree-apprenticeships-categories-desktop" data-corresponding-child-menu-id="train-to-be-a-teacher-teacher-degree-apprenticeships-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/train-to-be-a-teacher/teacher-degree-apprenticeships">
						<span class="menu-title">If you want to do a teaching apprenticeship</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="funding-and-support-courses-with-fees-pages-desktop">
				<li id="funding-and-support-tuition-fees-desktop" class="" data-corresponding-id="funding-and-support-tuition-fees-mobile" data-child-menu-id="funding-and-support-tuition-fees-categories-desktop" data-corresponding-child-menu-id="funding-and-support-tuition-fees-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/tuition-fees">
						<span class="menu-title">Tuition fees</span>
					</a>
				</li>
				<li id="funding-and-support-tuition-fee-and-maintenance-loans-desktop" class="" data-corresponding-id="funding-and-support-tuition-fee-and-maintenance-loans-mobile" data-child-menu-id="funding-and-support-tuition-fee-and-maintenance-loans-categories-desktop" data-corresponding-child-menu-id="funding-and-support-tuition-fee-and-maintenance-loans-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/tuition-fee-and-maintenance-loans">
						<span class="menu-title">Student finance for teacher training</span>
					</a>
				</li>
				<li id="funding-and-support-scholarships-and-bursaries-desktop" class="" data-corresponding-id="funding-and-support-scholarships-and-bursaries-mobile" data-child-menu-id="funding-and-support-scholarships-and-bursaries-categories-desktop" data-corresponding-child-menu-id="funding-and-support-scholarships-and-bursaries-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/scholarships-and-bursaries">
						<span class="menu-title">Bursaries and scholarships</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="funding-and-support-courses-with-a-salary-pages-desktop">
				<li id="funding-and-support-salaried-teacher-training-desktop" class="" data-corresponding-id="funding-and-support-salaried-teacher-training-mobile" data-child-menu-id="funding-and-support-salaried-teacher-training-categories-desktop" data-corresponding-child-menu-id="funding-and-support-salaried-teacher-training-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/salaried-teacher-training">
						<span class="menu-title">Salaried teacher training</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="funding-and-support-extra-support-pages-desktop">
				<li id="funding-and-support-if-youre-disabled-desktop" class="" data-corresponding-id="funding-and-support-if-youre-disabled-mobile" data-child-menu-id="funding-and-support-if-youre-disabled-categories-desktop" data-corresponding-child-menu-id="funding-and-support-if-youre-disabled-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/if-youre-disabled">
						<span class="menu-title">Funding and support if you're disabled</span>
					</a>
				</li>
				<li id="funding-and-support-if-youre-a-parent-or-carer-desktop" class="" data-corresponding-id="funding-and-support-if-youre-a-parent-or-carer-mobile" data-child-menu-id="funding-and-support-if-youre-a-parent-or-carer-categories-desktop" data-corresponding-child-menu-id="funding-and-support-if-youre-a-parent-or-carer-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/if-youre-a-parent-or-carer">
						<span class="menu-title">Funding and support if you're a parent or carer</span>
					</a>
				</li>
				<li id="funding-and-support-if-youre-a-veteran-desktop" class="" data-corresponding-id="funding-and-support-if-youre-a-veteran-mobile" data-child-menu-id="funding-and-support-if-youre-a-veteran-categories-desktop" data-corresponding-child-menu-id="funding-and-support-if-youre-a-veteran-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/funding-and-support/if-youre-a-veteran">
						<span class="menu-title">Funding and support if you're a veteran</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="non-uk-teachers-if-you-want-to-train-to-teach-pages-desktop">
				<li id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-desktop" class="" data-corresponding-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-mobile" data-child-menu-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-desktop" data-corresponding-child-menu-id="non-uk-teachers-train-to-teach-in-england-as-an-international-student-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/train-to-teach-in-england-as-an-international-student">
						<span class="menu-title">Train to teach in England as a non-UK citizen</span>
					</a>
				</li>
				<li id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-desktop" class="" data-corresponding-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-mobile" data-child-menu-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-desktop" data-corresponding-child-menu-id="non-uk-teachers-fees-and-funding-for-non-uk-trainees-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/fees-and-funding-for-non-uk-trainees">
						<span class="menu-title">Fees and financial support for non-UK trainee teachers</span>
					</a>
				</li>
				<li id="non-uk-teachers-non-uk-qualifications-desktop" class="" data-corresponding-id="non-uk-teachers-non-uk-qualifications-mobile" data-child-menu-id="non-uk-teachers-non-uk-qualifications-categories-desktop" data-corresponding-child-menu-id="non-uk-teachers-non-uk-qualifications-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/non-uk-qualifications">
						<span class="menu-title">Qualifications you'll need to train to teach in England</span>
					</a>
				</li>
				<li id="non-uk-teachers-visas-for-non-uk-trainees-desktop" class="" data-corresponding-id="non-uk-teachers-visas-for-non-uk-trainees-mobile" data-child-menu-id="non-uk-teachers-visas-for-non-uk-trainees-categories-desktop" data-corresponding-child-menu-id="non-uk-teachers-visas-for-non-uk-trainees-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/visas-for-non-uk-trainees">
						<span class="menu-title">Apply for your visa to train to teach</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="non-uk-teachers-if-you-re-already-a-teacher-pages-desktop">
				<li id="non-uk-teachers-teach-in-england-if-you-trained-overseas-desktop" class="" data-corresponding-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-mobile" data-child-menu-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-desktop" data-corresponding-child-menu-id="non-uk-teachers-teach-in-england-if-you-trained-overseas-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/teach-in-england-if-you-trained-overseas">
						<span class="menu-title">Teach in England as a non-UK qualified teacher</span>
					</a>
				</li>
				<li id="non-uk-teachers-get-an-international-relocation-payment-desktop" class="" data-corresponding-id="non-uk-teachers-get-an-international-relocation-payment-mobile" data-child-menu-id="non-uk-teachers-get-an-international-relocation-payment-categories-desktop" data-corresponding-child-menu-id="non-uk-teachers-get-an-international-relocation-payment-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/get-an-international-relocation-payment">
						<span class="menu-title">Get an international relocation payment</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="non-uk-teachers-get-international-qualified-teacher-status-iqts-pages-desktop">
				<li id="non-uk-teachers-international-qualified-teacher-status-desktop" class="" data-corresponding-id="non-uk-teachers-international-qualified-teacher-status-mobile" data-child-menu-id="non-uk-teachers-international-qualified-teacher-status-categories-desktop" data-corresponding-child-menu-id="non-uk-teachers-international-qualified-teacher-status-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/international-qualified-teacher-status">
						<span class="menu-title">Gain the equivalent of English QTS, from outside the UK</span>
					</a>
				</li>
			</ol>
			<ol class="page-links-list hidden-menu" id="non-uk-teachers-if-you-re-from-ukraine-pages-desktop">
				<li id="non-uk-teachers-ukraine-desktop" class="" data-corresponding-id="non-uk-teachers-ukraine-mobile" data-child-menu-id="non-uk-teachers-ukraine-categories-desktop" data-corresponding-child-menu-id="non-uk-teachers-ukraine-categories-mobile" data-direct-link="true" data-toggle-secondary-navigation="false">
					<a class="menu-link link link--black link--no-underline" data-action="keydown.enter->navigation#handleNavMenuClick keydown.tab->navigation#handleMenuTab" href="/non-uk-teachers/ukraine">
						<span class="menu-title">Ukrainian teachers and trainees coming to the UK</span>
					</a>
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
      const icon = document.querySelector('#is-teaching-right-for-me-mobile > a > span.nav-icon');
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

    it('tabs to the next logical item (child/sibling/parent)', () => {
      const primaryLink = document.querySelector('#is-teaching-right-for-me-mobile .menu-link');
      const categoryLink = document.querySelector("#is-teaching-right-for-me-pay-and-benefits-desktop .menu-link");
      const pageLink = document.querySelector("#is-teaching-right-for-me-teacher-pay-and-benefits-desktop .menu-link");
      const viewAllInCategoryLink = document.querySelector("#menu-view-all-is-teaching-right-for-me-desktop .menu-link")
      const nextPrimaryLink = document.querySelector('#steps-to-become-a-teacher-mobile .menu-link');
      const enterEvent = new KeyboardEvent('keydown', { key: 'enter' });
      const tabEvent = new KeyboardEvent('keydown', { key: 'tab' });

      primaryLink.focus();
      // expand dropdown via keyboard
      primaryLink.dispatchEvent(enterEvent);
      // tab to first category link
      primaryLink.dispatchEvent(tabEvent);

      expect(document.activeElement).toEqual(categoryLink);

      // expand page links via keyboard
      categoryLink.dispatchEvent(enterEvent);
      // tab to first page link
      categoryLink.dispatchEvent(tabEvent);

      // quirky whitespace behaviour - need to trim strings to match
      expect(document.activeElement.textContent).toMatch(pageLink.textContent.trim());

      // focus on final category link
      viewAllInCategoryLink.focus();
      // tab to next primary link
      viewAllInCategoryLink.dispatchEvent(tabEvent);

      expect(document.activeElement).toEqual(nextPrimaryLink);
    });
  });
});
