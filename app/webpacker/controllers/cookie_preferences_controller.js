import CookiePreferences from "../javascript/cookie_preferences"
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'category' ]

  connect() {
    this.cookiePreferences = new CookiePreferences ;
    this.assignRadios() ;
  }

  assignRadios() {
    for(const category of this.categoryTargets) {
      const categoryName = category.getAttribute("data-category") ;
      const allowed = this.cookiePreferences.allowed(categoryName) ;
      const value = allowed ? '1' : '0' ;
      const radio = category.querySelector('input[type="radio"][value="' + value + '"]') ;

      if (radio)
        radio.checked = true ;
    }
  }

  toggle(event) {
    const category = event.target.name.toString().replace(/^cookies-/, '')
    const value = event.target.value ;

    this.cookiePreferences.setCategory(category, value) ;
  }
}
