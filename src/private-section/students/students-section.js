import { inject } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { RouteMapper } from 'aurelia-route-mapper';
import { User } from '../user';
import { ProgramApplicationService, AcademicSessionService } from '../../services';
import { routes as feesRoutes } from './fees/fees-section';
import { routes as coursesRoutes } from './courses/courses-section';

@inject(Router, RouteMapper, User, ProgramApplicationService, AcademicSessionService)
export class StudentsSection {
  program_applications = [];
  program_application = {};
  user;

  constructor(router, routeMapper, user, programApplicationService, academicSessionService) {
    this.router = router;
    this.routeMapper = routeMapper;
    this.user = user;
    this.programApplicationService = programApplicationService;
    this.academicSessionService = academicSessionService;
  }
  async activate() {
    let responses = await Promise.all([
      this.academicSessionService.getAcademicSessions(`active=true&order_by=id`),
      this.programApplicationService.getProgramApplications(`user_id=${this.user.id}`)
    ]);
    Object.assign(this.user, {academic_session: {...responses[0][0]}});     
    this.program_applications = [...responses[1]];
    this.programApplicationChanged();

    // return Promise.all([
    //   this.academicSessionService.getAcademicSessions(`active=true&order_by=id`),
    //   this.programApplicationService.getProgramApplications(`user_id=${this.user.id}`)
    // ]).then(responses => {
    //   Object.assign(this.user, {academic_session: {...responses[0][0]}});      
    //   this.program_applications = [...responses[1]];
    //   this.programApplicationChanged();
    // });
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
    // this.user = { ...this.user, program: { ...program }, department: { ...department }, level: { ...level } };
    Object.assign(this.user, {program: { ...program }, department: { ...department }, level: { ...level } });
    localStorage.setItem("department", JSON.stringify(department));
    localStorage.setItem("program", JSON.stringify(program));
    if (redirect) this.router.navigate('/students');

  }
}
export let routes = [
  { route: '/', redirect: 'courses' },
  { route: '/courses', name: 'courses-section', moduleId: './courses/courses-section', title: 'Courses', nav: false, settings: { childRoutes: coursesRoutes } },
  { route: '/grades', name: 'grades', moduleId: './grades/grades', title: 'Grades' },
  { route: '/fees', name: 'fees-section', moduleId: './fees/fees-section', title: 'Fees', nav: false, settings: { childRoutes: feesRoutes } },
  { route: '/payments', name: 'payments', moduleId: './payments/payments', title: 'Payments', nav: false}
];
