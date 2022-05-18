import { Controller } from 'stimulus';
import accessibleAutocomplete from 'accessible-autocomplete';
import Redacter from '../javascript/redacter';

export default class extends Controller {
  static openedClass = 'searchbox--opened';
  static targets = ['searchbar', 'label'];
  static values = { searchInputId: String };

  searchQuery = null;

  connect() {
    this.setupAccessibleAutocomplete();
    this.fixLabelAccessibility();
  }

  toggle(event) {
    event.preventDefault();

    if (this.element.classList.contains('open')) {
      this.element.classList.remove('open');
    } else {
      this.element.classList.add('open');
      this.input.focus();
    }
  }

  disconnect() {
    if (this.autocompleteWrapper) this.autocompleteWrapper.remove();

    this.clearAnalyticsSubmitter();
  }

  get searchInputId() {
    return 'searchbox__input';
  }

  get autocompleteWrapper() {
    return this.searchbarTarget.querySelector('.autocomplete__wrapper');
  }

  setupAccessibleAutocomplete() {
    accessibleAutocomplete({
      placeholder: 'Search',
      element: this.searchbarTarget,
      id: this.searchInputIdValue,
      displayMenu: 'overlay',
      minLength: 2,
      source: this.performXhrSearch.bind(this),
      confirmOnBlur: false,
      tNoResults: () => (this.searching ? 'Searching...' : 'No results found'),
      onConfirm: this.onConfirm.bind(this),
      templates: {
        inputValue: this.inputValueTemplate.bind(this),
        suggestion: this.formatResults.bind(this),
      },
    });
  }

  fixLabelAccessibility() {
    // We see a warning on Silktide that the input has no label.
    // To fix this we're going to try adding an aria-label to the
    // auto-complete input.
    if (this.hasLabelTarget) {
      this.input.ariaLabel = this.labelTarget.textContent;
    }
  }

  searchParams(query) {
    return (
      encodeURIComponent('search[search]') + '=' + encodeURIComponent(query)
    );
  }

  performXhrSearch(query, callback) {
    this.searching = true;

    if (this.delaySearchTimeout) {
      clearTimeout(this.delaySearchTimeout);
    }

    this.delaySearchTimeout = setTimeout(() => {
      this.searchQuery = query;
      this.scheduleSubmissionToAnalytics();

      const request = new XMLHttpRequest();
      request.open('GET', '/search.json?' + this.searchParams(query), true);
      request.timeout = 10 * 1000;
      request.onreadystatechange = () => {
        if (
          request.readyState === XMLHttpRequest.DONE &&
          request.status === 200
        ) {
          const results = JSON.parse(request.responseText);
          this.searching = false;
          callback(results);
        }
      };

      request.send();
    }, 500);
  }

  onConfirm(chosen) {
    if (chosen && chosen.link) {
      if (this.analyticsSubmitter) this.sendToAnalytics();

      window.location = chosen.link;
    }
  }

  inputValueTemplate(result) {
    if (result) return result.title;
  }

  formatResults(result) {
    if (result) return result.html;
  }

  get redactedQuery() {
    return new Redacter(this.searchQuery).redacted;
  }

  get googleAnalyticsId() {
    const gaId = document.body.getAttribute('data-analytics-ga-id');

    if (gaId && gaId.trim() !== '') return gaId;
  }

  scheduleSubmissionToAnalytics() {
    this.clearAnalyticsSubmitter();

    this.analyticsSubmitter = window.setTimeout(
      this.sendToAnalytics.bind(this),
      2000
    );
  }

  sendToAnalytics() {
    this.clearAnalyticsSubmitter();

    if (window.ga && this.googleAnalyticsId) {
      window.ga('create', this.googleAnalyticsId, 'auto');
      window.ga('set', 'title', 'Get Into Teaching: Search Get Into Teaching');
      window.ga(
        'set',
        'page',
        '/search?' + this.searchParams(this.redactedQuery)
      );
      window.ga('send', 'pageview');
    }
  }

  clearAnalyticsSubmitter() {
    if (!this.analyticsSubmitter) return;

    window.clearTimeout(this.analyticsSubmitter);
    this.analyticsSubmitter = null;
  }

  get input() {
    return this.searchbarTarget.querySelector('input');
  }
}
