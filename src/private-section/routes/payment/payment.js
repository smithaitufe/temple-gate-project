import { inject } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { doDecrypt } from '../../../utils';
import { PaymentService } from '../../../services';
import { User } from '../../user';


@inject(Router, User, PaymentService)
export class Payment {
  constructor(router, user, paymentService){
    this.router = router;
    this.user = user;
    this.paymentService = paymentService;
  }
  activate(params){    
    const { txn_ref } = params;    
    let encrypted = localStorage.getItem("pinit");
    let cond = !encrypted || typeof txn_ref == undefined;
    if (cond) {
      this.router.navigate("/")
    }
    else{
      this.paymentService.getPayments(`transaction_reference_no=${txn_ref}`).then(response => {        
        let payment = response[0];
        let pinit = doDecrypt(encrypted, `${payment.fee_id}${this.user.id}`);
        if(pinit && (txn_ref == pinit)){
          this.paymentService.queryPayment(payment.transaction_reference_no, payment.amount).then(response => {
            this.payment = response;
            delete localStorage.getItem("pinit");
          });          
        }else{
          this.router.navigate("/")
        }
      });      
    }
  }
}
