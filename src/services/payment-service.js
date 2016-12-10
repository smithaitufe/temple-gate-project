import { HttpClient } from 'aurelia-fetch-client';
import CryptoJS from 'crypto-js';
import { get, post, put } from '../utils';
import settings from '../settings';


export class PaymentService {

  constructor(){
    const { interswitch : { product_id, mac_key, currency, pay_item_id } } = settings;
    this.product_id = product_id;
    this.mac_key = mac_key;
    this.currency = currency;
    this.pay_item_id = pay_item_id;
  }
  get_student_payments(params = null){
    if(params){
      return get(`/api/v1/student_payments?${params}`)
    }
    return get(`/api/v1/student_payments`)
  }
  get_student_payment_by_id(student_payment_id){
    if(student_payment_id){
      return get(`/api/v1/student_payments/${student_payment_id}`)
    }
    throw new Error("Student payment id not specified")
  }


  generate_query_hash(transaction_reference_no){
    const { interswitch : { product_id, mac_key } } = settings
    let str = `${transaction_reference_no}${product_id}${mac_key}`;
    return this.perform_hash(str);
  }
  generate_payment_hash(transaction_reference_no, amount, site_redirect_url){
    const { interswitch : { product_id, pay_item_id, mac_key } } = settings
    let str = `${transaction_reference_no}${product_id}${pay_item_id}${amount}${site_redirect_url}${mac_key}`;
    return this.perform_hash(str);
  }
  query_payment(transaction_reference_no, amount){
    const { interswitch : { payment_post_url, product_id }} = settings;
    let http = new HttpClient().configure(config => {
      config.withDefaults({
          mode: 'cors',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin':'*',
            'Hash': this.generate_query_hash(transaction_reference_no)
          }
    })
  });
    let url = payment_post_url + `product_id=${product_id}&transactionreference=${transaction_reference_no}&amount=${amount}`
    return http.fetch(url, {method: 'get'}).then(response => response.json())
  }
  perform_hash(str){
    var hash = CryptoJS.SHA512(str);
    var outString =  hash.toString(CryptoJS.enc.Hex)
    return outString;
  }
}
