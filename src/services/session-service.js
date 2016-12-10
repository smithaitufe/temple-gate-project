import { get, post, put, destroy } from '../utils'
import { interswitch, tokenName } from '../settings'
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

  login(email, password){
    const data = {session: { email: email, password: password }}      
    this.clearSession(tokenName);        
    return post(`/api/v1/sessions`, data)        
  }
  logOut(){    
    return destroy('/api/v1/sessions').then((response) => {
        if(response.ok){            
          this.clearSession(tokenName)
        }
    })
  }
  setToken(token){
    localStorage.setItem(tokenName, token);
  }
  getToken(){
    return localStorage.getItem(tokenName)
  }
  clearSession(name){    
    if (localStorage.getItem(name) || localStorage.getItem(name) !== null) {       
      delete localStorage[name];   
    }    
  }
}
