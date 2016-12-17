export class CoursesSection {
  configureRouter(config){
    config.map(routes);
  }
}
export let routes = [
    { route: "/", name: "courses", moduleId: "./courses", title: "", nav: false },
    { route: "/:course_id", name: "course", moduleId: "./course", title: "Course", nav: false }
]
