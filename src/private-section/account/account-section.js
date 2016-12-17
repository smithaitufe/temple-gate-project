export class AccountSection{
  configureRouter(config){
    config.map(routes);
  }
}
export let routes = [
  { route: '/', name: 'profile', moduleId: './profile/profile', title: 'Profile', nav: false },
  { route: "/password", name: "password", moduleId: "./password/password", title: "Password", nav: false}
]
