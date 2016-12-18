export class CoursesSection {
  configureRouter(config){
    config.map(routes);
  }
}
export let routes = [
    { route: "/", name: "courses", moduleId: "./courses", title: "", nav: false },
    { route: "/:enrollment_id", name: "course", moduleId: "./course", title: "Course", nav: false },
    { route: '/registration', name: 'registration', moduleId: './registration/registration', title: 'Course Registration', nav: false }
]
