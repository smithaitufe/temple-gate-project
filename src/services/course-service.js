import { get, post, put } from '../utils'
export class CourseService {
  getCourses(params) {
    if (params) {
      return get(`/api/v1/courses?${params}`)
    }
    return get(`/api/v1/courses`)
  }
  getCourseById(id) {
    return new Promise((reject) => {
      if (!id || isNaN(id)) reject("Parameter not specified or invalid");
      return get(`/api/v1/courses/${id}`)
    });
  }
  saveCourse(course) {
    return new Promise((reject) => {
      if (!course) reject("Course parameter not specified");
      const { id } = course;
      const data = { course: course};
      if (id) {
        return put(`/api/v1/courses/${id}`, data)
      }
      return post(`/api/v1/courses`, data)
    })
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
}
