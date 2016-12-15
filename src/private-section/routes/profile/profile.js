import { inject } from 'aurelia-framework';
import { User } from '../../user';
import { TermService, StateService, LocalGovernmentAreaService, UserService } from '../../../services';

@inject(User, TermService, StateService, LocalGovernmentAreaService, UserService)
export class Profile{
  entity = {};
  genders = [];
  marital_statuses = [];
  states = [];
  local_government_areas = [];

  
  constructor(user, termService, stateService, lgaService, userService){
    this.user = user;
    this.termService = termService;
    this.stateService = stateService;
    this.lgaService = lgaService;
    this.userService = userService;
    
    Object.assign(this.entity, {...this.user});
    

  }
  activate(){
    this.termService.getTerms("name=gender").then(response => {this.genders = response;})
    this.termService.getTerms("name=marital_status").then(response => {this.marital_statuses = response;})
    this.stateService.getStates().then(response => {
      this.states = [...this.states, ...response];
      this.stateChanged(); 
    });    
  }
  stateChanged(){
    const { profile: { local_government_area }} = this.entity;
    this.lgaService.getLocalGovernmentAreas(`state_id=${local_government_area.state_id}`).then(response => {
        this.local_government_areas = [...response]
    })
  }

  saveClicked(){
    const { profile } = this.entity;
    this.userService.saveUserProfile(profile).then((response)=> {
      
    });

  }
}
