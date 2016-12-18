import { get, post, put } from '../utils'
export class CourseService {
  getCourses(params) {
    if (params) {
      return get(`/api/v1/courses?${params}`)
    }
    return get(`/api/v1/courses`)
  }
  getCourseById(id) {
    if (!id || isNaN(id)) throw new Error("Parameter not specified or invalid");
      return get(`/api/v1/courses/${id}`)
  }

  saveCourse(course) {
    if (!course) throw new Error("Course parameter not specified");
      const { id } = course;
      const data = { course: course};
      if (id) {
        return put(`/api/v1/courses/${id}`, data)
      }
      return post(`/api/v1/courses`, data)
  }
  getEnrolledCourses(params){
    if(params){
      return get(`/api/v1/course_enrollments?${params}`)
    }
    return get(`/api/v1/course_enrollments`);
  }
  getEnrolledCourseById(id){
    if(id){
      return get(`/api/v1/course_enrollments/${id}`)
    }
    throw new Error("Parameter not specified")
  }

  enroll(userId, academicSessionId, levelId, courses) {
    return new Promise((resolve, reject) => {
      courses.forEach(course => {
        const { id }  = course;
        course = Object.assign({}, {
          user_id: userId,
          academic_session_id: academicSessionId,
          level_id: levelId,
          course_id: id
        })
        post(`/api/v1/course_enrollment`, { course_enrollment: course }).then(() => {})
    })
  })
}


  getGrades(params = null){
    if(params) return get(`/api/v1/course_gradings?${params}`);
    return get(`/api/v1/course_gradings`);
  }
  saveGrade(grade){

  }
  computeGrade(){

  }

  getAssignedCourses(params){
    if(params) return get(`/api/v1/course_tutors?${params}`);
    return get(`/api/v1/course_tutors`)
  }
}
