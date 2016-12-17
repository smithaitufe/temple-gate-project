import { inject } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { ValidationControllerFactory, ValidationRules } from 'aurelia-validation';
import { BootstrapFormRenderer } from '../../../resources/renderers/bootstrap-form-renderer';
import { User } from '../../user';
import { TermService, FeeService, PaymentService, ServiceChargeService } from '../../../services';
import { printArea, generateRandomNo, doEncrypt } from '../../../utils';
import { siteUrl, institution } from '../../../settings';

@inject(Router, ValidationControllerFactory, User, TermService, FeeService, PaymentService, ServiceChargeService)
export class Fee {
  fee = {};
  academic_session = {};
  amount;
  total;
  transaction_reference_no = generateRandomNo();
  split_definitions;
  service_charge_amount;
  site_name = institution;


  constructor(router, controllerFactory, user, termService, feeService, paymentService, serviceChargeService) {
    this.router = router;
    this.controller = controllerFactory.createForCurrentScope();
    this.controller.addRenderer(new BootstrapFormRenderer());
    ValidationRules.ensure("amount").displayName("Amount").required().matches(/^\d+(\.\d{1,2})?$/).withMessage("${$displayName} is invalid").on(this);
    this.user = user;
    this.termService = termService;
    this.feeService = feeService;
    this.paymentService = paymentService;
    this.serviceChargeService = serviceChargeService;
  }
  activate(params) {
    const { fee_id } = params;
    const {id, academic_session, program } = this.user;
    this.academic_session = academic_session;

    this.feeService.getFeeById(+fee_id).then(response => {
      this.fee = response;
      this.amount = this.fee.amount;
      this.paymentService.getPayments(`user_id=${id}&academic_session_id=${academic_session.id}`).then((response) => {
        if (response.length === 0) {
            this.termService.getTerms(`name=payer_category&description=student`).then(response => {
              this.serviceChargeService.getServiceCharges(`program_id=${program.id}&payer_category_id=${response[0].id}`).then(response => {
                this.service_charge_amount = response[0].service_charge_splits.reduce((prev, service_charge_split, index) => {
                  return parseFloat(service_charge_split.amount) + parseFloat(prev);
                }, 0);
                this.split_definitions = this.paymentService.splitDefinitions(this.transaction_reference_no, response[0].service_charge_splits);
              });
            });
          } else {
            this.service_charge_amount = parseFloat(this.paymentService.interswitchCharge);
            this.split_definitions = this.paymentService.splitDefinitions(this.transaction_reference_no, []);
          }
      });

    });
  }

  useWebpay() {
    this.controller.validate().then(response => {
      if (response.valid) {
        this.total = (parseFloat(this.amount) + parseFloat(this.service_charge_amount)) * 100;
        this.paymentService = Object.assign(this.paymentService, { hash: this.paymentService.generatePaymentHash(this.transaction_reference_no, this.total) });
        let redirect_url = `${siteUrl}/payment`;
        let payment = {
          fee_id: this.fee.id,
          academic_session_id: this.academic_session.id,
          amount: this.amount,
          service_charge: this.service_charge_amount,
          online: true,
          transaction_reference_no: "" + this.transaction_reference_no,
          user_id: this.user.id,
          payment_date: new Date(),
          site_redirect_url: redirect_url
        };
        this.paymentService.savePayment(payment).then(response => {
          if(localStorage.getItem("pinit")) delete localStorage.getItem("pinit");
          localStorage.setItem("pinit", doEncrypt(payment.transaction_reference_no, `${payment.fee_id}${this.user.id}`));
          $('form#webpayForm').submit();
        });
      }
    });
  }
  useBank() {
    this.controller.validate().then(response => {
      if (response.valid) {
        printArea($('#area').attr('id'), 'Bank Payment Slip');
      }
    });
  }
}
