import { get, post, put } from '../utils'
import moment from 'moment';
export class FeeService {
  get_fees(params = null){
    if(params){
      return get(`/api/v1/fees?${params}`)
    }
    return get(`/api/v1/fees`)
  }
  get_fee_by_id(id){
    return get(`/api/v1/fees/${id}`)
  }
  save_fee(fee){
    const { id } = fee;
    if(id){
      return put(`/api/v1/fees/${id}`, {fee: fee})
    }
    return post(`/api/v1/fees`, {fee: fee})
  }

}
