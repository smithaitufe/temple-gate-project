import { inject } from 'aurelia-framework';
import { AcademicSessionService, PaymentService } from '../../../../services';
import { User } from '../../../user';

@inject(User, AcademicSessionService, PaymentService)
export class Payments {
  payments = [];
  academic_sessions = [];
  academic_session;
  
  constructor(user, academicSessionService, paymentService) {
    this.user = user;
    this.academicSessionService = academicSessionService;
    this.paymentService = paymentService;
  }
  async activate(){    
    this.academicSessionService.getAcademicSessions(`order_by_desc=id`).then(response => {
      this.academic_sessions = response;
    });
    // this.fetchPayments();    
  }
  fetchPayments(){
    const { id, program, department } = this.user;
    this.paymentService.getPayments(`user_id=${id}&academic_session_id=${this.academic_session.id}`).then(response => {
      this.payments = response;
    })
  }
}
