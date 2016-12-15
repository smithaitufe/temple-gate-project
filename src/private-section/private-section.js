import { inject } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { RouteMapper } from 'aurelia-route-mapper';
import { SessionService } from '../services';
import { User } from './user';

import { brand } from '../settings';

import { routes as studentsRoutes } from './routes/students/students-section';
import { routes as applicantsRoutes } from './routes/applicants/applicants-section';

@inject(RouteMapper, User, SessionService)
export class PrivateSection {
    role;
    constructor(routeMapper, user, sessionService) {
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
            Object.assign(this.user, {...response })
        });
    }
    roleChanged() {
      const { slug } = this.role;
      Object.assign(this.user, {role: {...this.role}});

      switch (slug){
        case "student":
          this.router.navigate("/students");
          break;
        case "applicant":
          this.router.navigate("/applicants");
          break;
        default:
          this.router.navigate("/");
      }            
    }
}
let routes = [
    { route: "/", redirect: "welcome" },
    { route: "/welcome", name: "welcome", moduleId: "./routes/welcome/welcome", title: "Welcome", nav: true },
    { route: "/profile", name: "profile", moduleId: "./routes/profile/profile", title: "Profile", nav: true },
    { route: "/students", name: "students-section", moduleId: "./routes/students/students-section", title: "Students", nav: true, settings: { childRoutes: studentsRoutes } },
    { route: "/applicants", name: "applicants-section", moduleId: "./routes/applicants/applicants-section", title: "Applicants", nav: true, settings: { childRoutes: applicantsRoutes } }
]
