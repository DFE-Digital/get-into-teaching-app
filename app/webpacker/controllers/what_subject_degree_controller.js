import { Controller } from '@hotwired/stimulus'
export default class extends Controller {
  static targets = ['noJSContainer', 'noJSDegreeSubject', 'noJSEnabled', 'degreeSubjectAutoComplete', 'degreeSubjectSelect']

  connect() {
    
    console.log('noJSContainerTarget',      this.noJSContainerTarget);
    console.log('noJSDegreeSubjectTarget',  this.noJSDegreeSubjectTarget);
    console.log('noJSEnabledTarget',        this.noJSEnabledTarget);
    console.log('degreeSubjectAutoCompleteTarget', this.degreeSubjectAutoCompleteTarget);
    console.log('degreeSubjectSelectTarget', this.degreeSubjectSelectTarget);
    console.log('degreeSubjectAutoComplete', thisdegreeSubjectAutoCompleteTarget);

    this.noJSEnabledTarget.value = "false";
    this.noJSContainerTarget.style.display = "none";
    this.degreeSubjectSelectTarget.disabled = false;
    this.degreeSubjectAutoCompleteTarget.style.display = "block";



    console.log(this.noJSEnabledTarget.value);



    // const radioButtons = this.degreeStagesContainerTarget.querySelectorAll('input[type="radio"]')
    // const checked = Array.from(radioButtons).find(r => r.checked)

    // this.degreeSubjectContainerTarget.querySelector('input.nojs-flag').value = false
    // this.degreeSubjectContainerTarget.querySelectorAll('.hide-with-javascript').forEach(c => c.style.display = "none");
    // this.degreeSubjectContainerTarget.querySelectorAll('.show-with-javascript').forEach(c => c.style.display = "block");
    // this.degreeSubjectContainerTarget.querySelectorAll(".enable-with-javascript").forEach(c => c.disabled = false);
    // if (checked) {
    //   this.toggleDegreeSubjectContainer(checked)
    // }
  }

}
