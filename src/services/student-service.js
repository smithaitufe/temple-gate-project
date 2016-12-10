import { get, post, put } from '../utils'
export class StudentService {
  get_students(params = null){
    if(params){
      return get(`/api/v1/students?${params}`)
    }
    return get(`/api/v1/students`)
  }
  get_student(params){
    if(params){
      return get(`/api/v1/students?${params}`)
    }
    throw new Error("Parameter not specified")
  }
  get_student_by_id(id){
    return get(`/api/v1/students/${id}`)
  }

  save_student(student){
    const { id } = student;
    if(id){
      return put(`/api/v1/students/${id}`, {student: student})
    }
    return post(`/api/v1/students`, {student: student})
  }
}
