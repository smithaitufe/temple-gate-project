import { inject } from 'aurelia-framework';
import { User } from '../../user';
import { ProgramApplicationService } from '../../../services';
import { routes as feesRoutes } from './fees/fees-section';
import { routes as coursesRoutes } from './courses/courses-section';

@inject(User, ProgramApplicationService)
export class StudentsSection {
  program_applications = [];

  constructor(user, programApplicationService) {
    this.user = user;
    this.programApplicationService = programApplicationService;
  }
  activate() {
    return this.programApplicationService.getProgramApplications(`user_id=${this.user.id}`).then(response => {
      this.program_applications = [...response];
    });
  }
  configureRouter(config) {
    config.map(routes);
  }
}
export let routes = [
  { route: "/", redirect: "courses" },
  { route: "/courses", name: "courses-section", moduleId: "./courses/courses-section", title: "Courses", nav: false, settings: { childRoutes: coursesRoutes } },
  { route: "/fees", name: "fees-section", moduleId: "./fees/fees-section", title: "Fees", nav: false, settings: { childRoutes: feesRoutes } }
]
