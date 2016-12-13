import { get, post, put } from '../utils'
export class StateService {
  getStates(params = null){
    if(params) return get(`/api/v1/states?${params}`)    
    return get(`/api/v1/states`)
  }
  getStateById(id){
    return new Promise((reject) => {
      if(!id) reject("Parameter not specified");
      return get(`/api/v1/states/${id}`);    
    });    
  }  
  saveState(state){
    return new Promise((reject) => {
      if (!state) reject("State parameter not specified");
      const { id } = state;
      if (id) return put(`/api/v1/states/${id}`, { state: state })
      return post(`/api/v1/states`, { state: state })
    })
  }
}
