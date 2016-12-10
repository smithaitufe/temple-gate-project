import { get, post, put, destroy } from '../utils'
import settings from '../settings'
export class SessionService {
  
  setCurrentRole(value){
    localStorage.setItem("access", JSON.stringify(value))
  }
  getCurrentRole(){
    return JSON.parse(localStorage.getItem("access"));
  }
  getCurrentUser(){
    return get(`/api/v1/current_user`)
  }

  beginSession(email, password){
    const data = {session: { email: email, password: password }}      
    this.clearSession(settings.token_name);        
    return post(`/api/v1/sessions`, data)        
  }
  endSession(){    
    return destroy('/api/v1/sessions').then((response) => {
        if(response.ok){            
          this.clearSession(settings.token_name)
        }
    })
  }
  assign_token(token){
    localStorage.setItem(settings.token_name, token);
  }
  setToken(token){
    localStorage.setItem(settings.token_name, token);
  }
  getToken(){
    return localStorage.getItem(settings.token_name)
  }
  clearSession(name){    
    if (localStorage.getItem(name) || localStorage.getItem(name) !== null) {       
      delete localStorage[name];   
    }    
  }
}
