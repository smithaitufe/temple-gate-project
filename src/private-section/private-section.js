import { inject, Aurelia } from 'aurelia-framework';
import { Router, Redirect } from 'aurelia-router';
import { RouteMapper } from 'aurelia-route-mapper';
import { SessionService } from '../services';
import { User } from './user';
import { brand } from '../settings';
import { routes as accountRoutes } from './account/account-section';
import { routes as studentsRoutes } from './students/students-section';
import { routes as applicantsRoutes } from './applicants/applicants-section';
import { routes as facultiesRoutes } from './faculties/faculties-section';


@inject(Aurelia, Router, RouteMapper, User, SessionService)
export class PrivateSection {
  role;
  constructor(aurelia, router, routeMapper, user, sessionService) {
    this.aurelia = aurelia;
    this.router = router;
    this.routeMapper = routeMapper;
    this.user = user;
    this.sessionService = sessionService;    
  }
  configureRouter(config, router) {
    config.title = brand;
    config.options.pushState = true;
    config.addPipelineStep("authorize", PrivateSectionAuthContext);
    config.map(routes);
    this.routeMapper.map(routes);
    this.router = router;
  }
  activate() {    
    return this.sessionService.getCurrentUser().then(response => {
      Object.assign(this.user, { ...response })
    });
  }
  roleChanged() {
    const { slug } = this.role;
    this.user = Object.assign(this.user, { role: { ...this.role } });
    this.sessionService.setCurrentRole(this.role);
    switch (slug) {
      case "student":
        this.router.navigate("/students");
        break;
      case "applicant":
        this.router.navigate("/applicants");
        break;
    }
  }
  logOut() {
    this.sessionService.logOut().then(() => {
      this.router.navigate("/account/login", { replace: true, trigger: false });
      this.aurelia.setRoot("main-app/app");
      this.router.refreshNavigation();
    })
  }
}
let routes = [
  { route: '/', redirect: 'welcome' },
  { route: '/welcome', name: 'welcome', moduleId: './welcome/welcome', title: 'Welcome', nav: true, auth: true, settings: {roles: []} },
  { route: '/account', name: 'account-section', moduleId: './account/account-section', title: 'Account', nav: true, auth: true, settings: {childRoutes: accountRoutes} },
  { route: '/students', name: 'students-section', moduleId: './students/students-section', title: 'Students', nav: true, auth: true, settings: { childRoutes: studentsRoutes, roles: ['student'] } },
  { route: '/applicants', name: 'applicants-section', moduleId: './applicants/applicants-section', title: 'Applicants', nav: true, settings: { childRoutes: applicantsRoutes, roles: ['applicant'] } },
  { route: '/faculties', name: 'faculties-section', moduleId: './faculties/faculties-section', title: 'Faculties', nav: true, settings: { childRoutes: facultiesRoutes, roles: ['student'] } },
  { route: '/payment', name: 'payment', moduleId: './payment/payment', title: 'Payment', nav: true },
  { route: '/denied', name: 'denied', moduleId: './denied/denied', title: '', nav: false }
];

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
        if (!role) this.doRedirect(next);
        let allowed = this.roles.some(slug => slug === role.slug);
        if (allowed) return next();
        return this.doRedirect(next);
      }
      return next();
    }
    return next();
  }
  doRedirect(next) {
    return next.cancel(new Redirect('denied'));
  }
}
