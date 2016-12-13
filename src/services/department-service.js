import { get, post, put } from '../utils';
export class DepartmentService {
  getDepartments(params = null) {
    if (params === null)
      return get(`/api/v1/departments`)
    return get(`/api/v1/departments?${params}`)
  }
  getDepartmentById(id) {
    return new Promise((reject) => {
      if (!id) reject("Parameter not specified")
      return get(`/api/v1/departments/${id}`)
    })
  }
  saveDepartment(params) {
    return new Promise((reject) => {
      if(!params) reject("Department parameter not specified");
      const { id } = department;
      const data = { department: params }
      if (id) return post(`/api/v1/departments/${id}`, data)
      return post(`/api/v1/departments`, data)
    })

  }
  getDepartmentsByPrograms(params = null) {
    if (params === null)
      return get(`/api/v1/program_departments`)
    return get(`/api/v1/program_departments?${params}`)
  }
}
