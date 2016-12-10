import { get, post, put } from '../utils'
export class CourseService {
  get_courses(params = null){
    if(params){
      return get(`/api/v1/courses?${params}`)
    }
    return get(`/api/v1/courses`)
  }
  get_course_by_id(id){
    return get(`/api/v1/courses/${id}`)
  }

  save_course(course){
    const { id } = course;
    if(id){
      return put(`/api/v1/courses/${id}`, {course: course})
    }
    return post(`/api/v1/courses`, {course: course})
  }

  register_courses(student, academic_session, course_list){
    course_list.forEach(course => {
      course = Object.assign({}, {...course}, {student_id: student.id, academic_session_id: academic_session.id})
      post(`/api/v1/student_courses`, {student_course: student_course})
    })
  }
  drop_courses(course_list){
    course_list.forEach( course => {

    })
  }
  update_registered_courses(courses){

  }
}
