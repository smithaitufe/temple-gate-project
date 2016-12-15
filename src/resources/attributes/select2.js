import {customAttribute, inject} from 'aurelia-framework';
//import $ from 'jquery';
//import select2 from 'select2'; // install the select2 jquery plugin
//import from 'select2/css/select2.min.css' // ensure the select2 stylesheet has been loaded

@customAttribute('select2')
@inject(Element)
export class Select2CustomAttribute {
  constructor(element) {
    this.element = element;
  }

  attached() {
    $(this.element).select2(this.value)
      .on('change', () => this.element.dispatchEvent(new Event('change')));
  }

  detached() {
    $(this.element).select2('destroy');
  }
}
