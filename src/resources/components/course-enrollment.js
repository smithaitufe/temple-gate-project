import { bindable } from 'aurelia-framework';

export class CourseEnrollment {
  @bindable courses = [];
  @bindable selections = [];

  selectionsChanged(newValue){
    console.log(newValue);
    
  }
  
}
