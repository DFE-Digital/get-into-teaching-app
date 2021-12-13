import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['category'];

  connect() {
    this.cookiePreferences = new CookiePreferences();
    this.assignRadios();
  }

  assignRadios() {
    for (const category of this.categoryTargets) {
      const categoryName = category.getAttribute('data-category');
      const allowed = this.cookiePreferences.allowed(categoryName);
      const value = allowed ? '1' : '0';
      const radio = category.querySelector(
        'input[type="radio"][value="' + value + '"]'
      );

      if (radio) radio.checked = true;
    }
  }

  toggle(_event) {
    this.data.set('save-state', 'unsaved');
  }

  save(event) {
    event.preventDefault();

    const categories = this.categoryTargets.reduce((acc, fieldset) => {
      const category = fieldset.getAttribute('data-category');
      const field = fieldset.querySelector('input[type="radio"]:checked');

      if (field) {
        return { ...acc, [category]: field.value };
      } else {
        return acc;
      }
    }, {});

    this.cookiePreferences.setCategories(categories);

    this.data.set('save-state', 'saving');
    window.setTimeout(this.finishSave.bind(this), 600);
  }

  finishSave() {
    if (this.data.get('save-state') === 'saving')
      this.data.set('save-state', 'saved');
  }
}
