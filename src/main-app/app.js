import { inject } from 'aurelia-framework';
import {ValidationController, validateTrigger} from 'aurelia-validation';
import { RouteMapper } from 'aurelia-route-mapper';

import { routes as programsRoutes } from './routes/programs/programs-section';

@inject(RouteMapper)
export class App {
  constructor(routeMapper){
    this.routeMapper = routeMapper;
  }
  configureRouter(config, router) {
    config.title = 'Aurelia';
    config.options.pushState = true;
    config.map(routes);
    this.routeMapper.map(routes);
    this.router = router;
  }
}
let routes = [
  { route: ['', 'welcome'], name: 'welcome',      moduleId: './routes/welcome/welcome',      nav: true, title: 'Welcome' },
  { route: "/login", name: "login", moduleId: "./login/login", title: "Login", nav: false},
  { route: "/programs", name: "programs-section", moduleId: "./routes/programs/programs-section", title: "Programs", nav: false, settings: { childRoutes: programsRoutes}}
]
ValidationController.prototype.validateTrigger = validateTrigger.change;
