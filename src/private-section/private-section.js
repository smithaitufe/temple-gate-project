import { inject, Aurelia } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { RouteMapper } from 'aurelia-route-mapper';
import { SessionService } from '../services';
import { User } from './user';

import { brand } from '../settings';
import { routes as accountRoutes } from './account/account-section';
import { routes as studentsRoutes } from './students/students-section';
import { routes as applicantsRoutes } from './applicants/applicants-section';

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

    switch (slug) {
      case "student":
        this.router.navigate("/students");
        break;
      case "applicant":
        this.router.navigate("/applicants");
        break;
      // default:
      //   this.router.navigate("/");
      //   break;
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
  { route: '/welcome', name: 'welcome', moduleId: './welcome/welcome', title: 'Welcome', nav: true },
  { route: '/account', name: 'account-section', moduleId: './account/account-section', title: 'Account', nav: true, settings: {childRoutes: accountRoutes} },
  { route: '/students', name: 'students-section', moduleId: './students/students-section', title: 'Students', nav: true, settings: { childRoutes: studentsRoutes } },
  { route: '/applicants', name: 'applicants-section', moduleId: './applicants/applicants-section', title: 'Applicants', nav: true, settings: { childRoutes: applicantsRoutes } },
  { route: '/payment', name: 'payment', moduleId: './payment/payment', title: 'Payment', nav: true }
];
