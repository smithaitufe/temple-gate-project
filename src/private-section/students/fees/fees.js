import { inject } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { User } from '../../user';
import { FeeService } from '../../../services';

@inject(Router, User, FeeService)
export class Fees {
  constructor(router, user, feeService){
    this.router = router;
    this.user = user;
    this.feeService = feeService;
  }
  activate(){
    const { profile: { local_government_area: state }, program, level } = this.user;
    let params = `is_catchment=${state.is_catchment_area}&program_id=${program.id}&level_id=${level.id}`;
    this.feeService.getFees(params).then((response) => {
      this.fees = response;
    });
  }
  open(id){
    this.router.navigateToRoute("fee", {fee_id: id});
  }
}
