import { bindable } from 'aurelia-framework';

export class Webpay {
    @bindable amount;
    @bindable payment_post_url;
    @bindable cust_id;
    @bindable cust_name;
    @bindable site_redirect_url;
    @bindable hash;
    @bindable xml_data;
    @bindable pay_item_id;
    @bindable product_id;
    @bindable button_text;
}