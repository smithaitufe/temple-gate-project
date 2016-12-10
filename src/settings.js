export default {
  rest_url: 'http://localhost:4000',
  site_url: "http://127.0.0.1:9000",
  token_name: "cupid16_t",
  recaptcha_site_key: "6Ld1xSUTAAAAAGlo03e4qEIGpp6UcLlWYfrsbph9",
  recaptcha_secret_key: "6Ld1xSUTAAAAADz16z7ybX-reufvQmFNHcPApjY0",
  remita: {
    merchant_id: "2547916",
    service_type_id: "4430731",
    api_key: "1946",
    basic_url: "http://www.remitademo.net/remita/ecomm/init.reg",
    split_url: "http://www.remitademo.net/remita/ecomm/split/init.reg",
    status_request_url: "http://www.remitademo.net/remita/ecomm/merchantId/RRR/hash/status.reg",
  },

  interswitch: {
    default_post_url: "https://stageserv.interswitchng.com/test_paydirect/pay",
    mac_key: 'D3D1D05AFE42AD50818167EAC73C109168A0F108F32645C8B59E897FA930DA44F9230910DAC9E20641823799A107A02068F7BC0F4CC41D2952E249552255710F',
    product_id: 6205,
    pay_item_id: 101,
    currency: 566,
    post_url: '',
    school_account_name: '',
    school_account_no: '',
    school_account_bank: '',
    provider_account_name: '',
    provider_account_no: '',
    provider_account_bank: '',
    paymentPage: "https://stageserv.interswitchng.com/test_paydirect/pay",
    transactionQuery: "https://stageserv.interswitchng.com/test_paydirect/api/v1/gettransaction.json"
  }
}
