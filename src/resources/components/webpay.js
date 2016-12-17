import { bindable } from 'aurelia-framework';

export class Webpay {
    @bindable amount;
    @bindable post_url;
    @bindable currency;
    @bindable site_name;
    @bindable cust_id;
    @bindable txn_ref;
    @bindable last_name;
    @bindable first_name;
    @bindable site_redirect_url;
    @bindable hash;
    @bindable xml_data;
    @bindable pay_item_id;
    @bindable pay_item_name;
    @bindable product_id;
    @bindable button_text = "Web Pay";
    @bindable submitCallback = () => {};
}
