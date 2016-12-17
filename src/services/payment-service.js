import { get, post, put, hashString } from '../utils';
import { interswitch, institution, restUrl } from '../settings';



export class PaymentService {

  constructor(){
    const { productId, macKey, currency, payItemId, charge, paymentPostUrl, payItemName } = interswitch;
    this.productId = productId;
    this.macKey = macKey;
    this.currency = currency;
    this.payItemId = payItemId;
    this.interswitchCharge = charge;
    this.redirectUrl = restUrl + '/api/v1/interswitch/webpay';
    this.paymentPostUrl = paymentPostUrl;
    this.payItemName = payItemName;
    
  }
  getPayments(params = null){
    if(params){
      return get(`/api/v1/payments?${params}`)
    }
    return get(`/api/v1/payments`)
  }
  getPaymentById(id){
    if(id){
      return get(`/api/v1/payments/${id}`)
    }
    throw new Error("Student payment id not specified")
  }
  savePayment(payment = null){
    if(!payment) throw new Error("Payment parameter not specified");
    const { id } = payment;
    const data = {payment: payment};
    if(id) return put(`/api/v1/payments/${id}`, data);
    return post(`/api/v1/payments`, data)
  }
  generateQueryHash(transactionReferenceNo){    
    let str = `${transactionReferenceNo}${this.productId}${this.macKey}`;
    return hashString(str);
  }
  generatePaymentHash(transactionReferenceNo, amount){
    let str = `${transactionReferenceNo}${this.productId}${this.payItemId}${amount}${this.redirectUrl}${this.macKey}`;
    return hashString(str);
  }
  queryPayment(transactionReferenceNo, amount){     
    let params = `product_id=${this.productId}&transaction_reference_no=${transactionReferenceNo}&amount=${amount}`
    params = params + `&url=${interswitch.transactionQueryUrl}&hash=${this.generateQueryHash(transactionReferenceNo)}`
    return get(`/api/v1/interswitch/webpay?${params}`); 
  }
  splitDefinitions(transactionReferenceNo, serviceChargeSplits)  {
    let item_details = serviceChargeSplits.reduce((prev, serviceChargeSplit, index) => {
      if(serviceChargeSplit.is_required) return `<item_detail item_id="${index + 1}" item_name="${serviceChargeSplit.name} item_amt="${parseFloat(serviceChargeSplit.amount) * 100}" acc_num="${serviceChargeSplit.account}" bank_id="${serviceChargeSplit.bank_code}" />`+prev;
    },"")
    return `
    <payment_item_detail>
    <item_details detail_ref="${transactionReferenceNo}" institution="${institution}">
    ${item_details}
    </item_details>
    </payment_item_detail>
    `;

  }
}
export class ServiceChargeService{
  getServiceCharges(params){
    if(params) return get(`/api/v1/service_charges?${params}`)
    return get(`/api/v1/service_charges`);
  }
  getServiceChargeById(id){
    if(!id) throw new Error("Parameter not specified");
    return get(`/api/v1/service_charges/${id}`);
  }
  saveServiceCharge(serviceCharge){
    return new Promise((reject) => {
      if(!serviceCharge) reject("Service charge parameter not specified");
      const { id } = serviceCharge;
      const data = { service_charge: serviceCharge};
      if(id) return put(`/api/v1/service_charges/${id}`, data);
      return post(`api/v1/service_charges`, data);
    });    
  }
  getServiceChargeSplits(params){
    if(params) return get(`/api/v1/service_charge_splits?${params}`)
    return get(`/api/v1/service_charge_splits`);
  }
  getServiceChargeSplitById(id){
    if(!id) throw new Error("Parameter not specified");
    return get(`/api/v1/service_charge_splits/${id}`);
  }
  saveServiceChargeSplit(serviceChargeSplit){
    return new Promise(reject => {
      if(!serviceChargeSplit) reject("Service charge split parameter not specified");
      const { id } = serviceChargeSplit;
      const data = { service_charge_split: serviceChargeSplit};
      if(id) return put(`/api/v1/service_charge_splits/${id}`, data);
      return post(`api/v1/service_charge_splits`, data);      
    });    
  }
}
