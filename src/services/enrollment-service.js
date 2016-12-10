import { get, post, put } from '../utils';

export class EnrollmentService {
  get_enrolled_courses(params){
    if(params){
      return get(`/api/v1/student_courses?${params}`)
    }
    return get(`/api/v1/student_courses`)
  }
  get_enrolled_course_by_id(id){
    return get(`/api/v1/student_courses/${id}`)
  }
  enroll_courses(student_id, academic_session_id, course_ids){
    return new Promise(resolve => {
      course_ids.forEach(course_id => {
        let student_course = {student_id: student_id, academic_session_id: academic_session_id, course_id: course_id}
        post(`/api/v1/student_courses`, {student_course: student_course}).then(()=>{})
      })
      resolve();
    })
  }








}
