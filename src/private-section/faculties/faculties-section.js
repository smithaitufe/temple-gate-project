import { routes as lecturersRoutes } from './lecturers/lecturers-section';

export class FacultiesSection {
  configureRouter(config) {
    config.map(routes);
  }
}
export let routes = [
  { route: '/lecturers', name: 'lecturers-section', moduleId: './lecturers/lecturers-section', title: 'Lecturer', nav: false, settings: {childRoutes: lecturersRoutes}}
];
