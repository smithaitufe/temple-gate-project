import { HttpClient } from 'aurelia-fetch-client';
import CryptoJS from 'crypto-js';
import { get, post, put } from '../utils';
import { interswitch } from '../settings';


export class PaymentService {

  constructor(){
    const { productId, macKey, currency, payItemId } = interswitch;
    this.productId = productId;
    this.macKey = macKey;
    this.currency = currency;
    this.payItemId = payItemId;
  }
  getPayments(params = null){
    if(params){
      return get(`/api/v1/payments?${params}`)
    }
    return get(`/api/v1/payments`)
  }
  getPaymentById(id){
    if(id){
      return get(`/api/v1/payments/${student_payment_id}`)
    }
    throw new Error("Student payment id not specified")
  }
  generateQueryHash(transactionReferenceNo){
    const { productId, macKey } = interswitch;
    let str = `${transactionReferenceNo}${productId}${macKey}`;
    return this.performHash(str);
  }
  generatePaymentHash(transactionReferenceNo, amount, siteRedirectUrl){
    const { interswitch : { productId, payItemId, macKey } } = settings
    let str = `${transactionReferenceNo}${productId}${payItemId}${amount}${siteRedirectUrl}${macKey}`;
    return performHash(str);
  }
  queryPayment(transactionReferenceNo, amount){
    const { paymentPostUrl, productId } = interswitch;
    let http = new HttpClient().configure(config => {
      config.withDefaults({
          mode: 'cors',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin':'*',
            'Hash': this.generateQueryHash(transactionReferenceNo)
          }
    })
  });
    let url = paymentPostUrl + `productid=${productId}&transactionreference=${transactionReferenceNo}&amount=${amount}`
    return http.fetch(url, {method: 'get'}).then(response => response.json())
  }  
}

const performHash = (str) => {
    var hash = CryptoJS.SHA512(str);
    var outString =  hash.toString(CryptoJS.enc.Hex)
    return outString;
}

export class ServiceChargeService{
  getServiceCharges(params){
    if(params) return get(`/api/v1/service_charges?${params}}`)
    return get(`/api/v1/service_charges`);
  }
  getServiceChargeById(id){
    if(!id) throw new Error("Parameter not specified");
    return get(`/api/v1/service_charges/${id}`);
  }
  saveServiceCharge(serviceCharge){
    new Promise((reject) => {
      if(!serviceCharge) reject();
      const { id } = serviceCharge;
      const data = { service_charge: serviceCharge};
      if(id) return put(`/api/v1/service_charges/${id}`, data);
      return post(`api/v1/service_charges`, data);
    }    
  }

}

export class PaymentSplitService{
  getPaymentSplits(params){
    if(params) return get(`/api/v1/payment_splits?${params}}`)
    return get(`/api/v1/payment_splits`);
  }
  getPaymentSplitById(id){
    if(!id) throw new Error("Parameter not specified");
    return get(`/api/v1/payment_splits/${id}`);
  }
  savePaymentSplit(paymentSplit){
    return new Promise(reject => {
      if(!paymentSplit) reject();
      const { id } = paymentSplit;
      const data = { payment_split: paymentSplit};
      if(id) return put(`/api/v1/payment_splits/${id}`, data);
      return post(`api/v1/payment_splits`, data);      
    }    
  }
}
