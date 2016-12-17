
export class ApplicantsSection{
  configureRouter(config){
    config.map(routes);
  }
}

export let routes = [
  { route: "/", redirect: "application"},
  { route: "/applications", name: "applications", moduleId: "./applications/applications", title: "Applications", nav: false},
  { route: "/certificates", name: "certificates", moduleId: "./certificates/certificates", title: "Certificates", nav: false}
]
