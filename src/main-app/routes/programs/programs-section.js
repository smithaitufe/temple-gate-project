export class ProgramsSection{
  configureRouter(config){
    config.map(routes);
  }
}
export let routes = [
  { route: "/", name: "programs", moduleId: "./programs", title: "", nav: false},  
]
