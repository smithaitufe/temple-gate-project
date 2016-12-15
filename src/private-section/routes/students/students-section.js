import { inject } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { RouteMapper } from 'aurelia-route-mapper';
import { User } from '../../user';
import { ProgramApplicationService } from '../../../services';
import { routes as feesRoutes } from './fees/fees-section';
import { routes as coursesRoutes } from './courses/courses-section';

@inject(Router, RouteMapper, User, ProgramApplicationService)
export class StudentsSection {
  program_applications = [];
  program_application = {};

  constructor(router, routeMapper, user, programApplicationService) {
    this.router = router;
    this.routeMapper = routeMapper;
    this.user = user;
    this.programApplicationService = programApplicationService;
  }
  activate() {
    return this.programApplicationService.getProgramApplications(`user_id=${this.user.id}`).then(response => {
      this.program_applications = [...response];
      this.programApplicationChanged();
    });
  }
  configureRouter(config) {
    config.map(routes);
  }
  programApplicationChanged() {
    if (Object.getOwnPropertyNames(this.program_application).length === 0) this.program_application = this.program_applications[0];
    const { program, department, level } = this.program_application;
    let redirect = true;
    let previous_department = JSON.parse(localStorage.getItem("department"));
    let previous_program = JSON.parse(localStorage.getItem("program"));
    if (previous_department && previous_program) {
      if (previous_department.name == department.name && previous_program.name == program.name) {
        redirect = false;
      }
    }
    Object.assign(this.user, { program: { ...program }, department: { ...department }, level: { ...level } });
    localStorage.setItem("department", JSON.stringify(department));
    localStorage.setItem("program", JSON.stringify(program));
    if (redirect) this.router.navigate('/students');

  }
}
export let routes = [
  { route: '/', redirect: 'courses' },
  { route: '/courses', name: 'courses-section', moduleId: './courses/courses-section', title: 'Courses', nav: false, settings: { childRoutes: coursesRoutes } },
  { route: '/enrollment', name: 'enrollment', moduleId: './enrollment/enrollment', title: 'Enrollment', nav: false },
  { route: '/fees', name: 'fees-section', moduleId: './fees/fees-section', title: 'Fees', nav: false, settings: { childRoutes: feesRoutes } }
];
