import { get, post, put } from '../utils'
export class StudentCourseService {
  get_student_courses(params = null){
    if(params){
      return get(`/api/v1/student_courses?${params}`)
    }
    return get(`/api/v1/student_courses`)
  }
  get_student_course_by_id(id){
    return get(`/api/v1/student_courses/${id}`)
  }

  save_student_course(student, academic_session, course_list){
    course_list.forEach(course => {
      course = Object.assign({}, {...course}, {student_id: student.id, academic_session_id: academic_session.id})
      post(`/api/v1/student_courses`, {student_course: student_course})
    })
  }

}
