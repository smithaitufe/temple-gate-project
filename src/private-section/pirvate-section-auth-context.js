import { inject, Aurelia } from 'aurelia-framework';
@inject(Aurelia, SessionService)
export class PrivateSectionAuthContext {
  
  constructor(aurelia, sessionService) {
    this.aurelia = aurelia;
    this.sessionService = sessionService;
    this.roles = [];
  }
  run(routingContext, next) {
    if (routingContext.getAllInstructions().some(i => {
      if(i.config.auth){
        const { roles } = i.config.settings;
        this.roles = roles;
        return true;
      }
    })) {
      
      let role = this.sessionService.getCurrentRole();
      if (this.roles && this.roles.length > 0) {
        console.log(this.roles);
        if (!Object.getOwnPropertyNames(role).length) doRedirect(next);
        let allowed = this.roles.some(slug => slug === role.slug);
        if (allowed) return next();
        return doRedirect(next);
      }
      return next();
    }
    return next();
  }
  doRedirect(next) {
    return next.cancel(new Redirect('denied'));
  }
}
