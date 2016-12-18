import { inject } from 'aurelia-framework';
import { ValidationControllerFactory, ValidationRules } from 'aurelia-validation';

@inject(ValidationControllerFactory)
export class Course{
  constructor(controllerFactory){
    this.controller = controllerFactory.createForCurrentScope();
  }
}
