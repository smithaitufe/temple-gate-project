export class AccountSection{
  configureRouter(config){
    config.map(routes);
  }
}
export let routes = [
  { route: "/", redirect: "login"},
  { route: "/login", name: "login", moduleId: "./login/login", title: "Login", nav: false},
  { route: "/password", name: "password", moduleId: "./password/password", title: "Password", nav: false}
]
