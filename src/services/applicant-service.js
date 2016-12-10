import {get, post, put } from '../utils';
export class ApplicantService {
  get_applicants(params = null){
    if(params){

    }
    return get(`/api/v1/students`)
  }
  get_applicant_by_id(id){
    return get(`/api/v1/students/${id}`)
  }


}
