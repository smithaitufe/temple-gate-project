import { get, post, put } from '../utils'
import moment from 'moment';
export class FeeService {
  getFees(params = null) {
    if (params) {
      return get(`/api/v1/fees?${params}`)
    }
    return get(`/api/v1/fees`)
  }
  getFeeById(id) {
    return new Promise((reject) => {
      if (!id) reject("Paramter not specified")
      return get(`/api/v1/fees/${id}`)
    });
  }
  saveFee(params) {
    return new Promise((reject) => {
      if(!params) reject("Paramter not specified");
      const data =  { fee: params };
      const { id } = params;
      if (id) return put(`/api/v1/fees/${id}`, data);
      return post(`/api/v1/fees`, data);
    });
  }

}
