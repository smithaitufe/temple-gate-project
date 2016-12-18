export class LecturersSection {
  
}

export let routes = [
  { route: '/', redirect: 'courses'},
  { route: '/courses', name: 'courses', moduleId: './courses/courses', title: 'Courses'},
  { route: '/enrollments', name: 'enrollments-section', moduleId: './enrollments/enrollments-section', title: 'Enrollment'}
]
