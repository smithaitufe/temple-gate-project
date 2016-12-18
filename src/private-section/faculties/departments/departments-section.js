export class DepartmentsSection {
  configureRouter(config){
    config.map(routes);
  }

}
export let routes = [
  {route: '/', name: 'departments', moduleId: './departments', title: '', nav: false },
  // {route: '/', name: 'department', moduleId: './department', title: '', nav: false }
  
]
