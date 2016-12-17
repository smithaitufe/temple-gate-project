import { bindable } from 'aurelia-framework';
export class Bank {
  @bindable user;
  @bindable amount;
  @bindable charge;
  @bindable description;
  @bindable caption = 'Print Bank Branch Slip';
  @bindable printCallback = () => { };
  @bindable rules = 'btn btn-default';
  @bindable academic_session;
  date_printed;
  constructor() {
    this.date_printed = new Date();
  }
}
