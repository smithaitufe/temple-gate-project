import { get, post, put } from '../utils';

export class TermService {
  getTerms(params = null){
    if(params) return get(`/api/v1/terms?${params}`)
    return get(`/api/v1/terms`)
  }
}
