import { get, post, put} from '../utils';
export class DepartmentService {
  getDepartments(params = null){
    if(params === null)
      return get(`/api/v1/departments`)
    return get(`/api/v1/departments?${params}`)
  }
  get_department_by_id(id){
    return get(`/api/v1/departments/${id}`)
  }
  save_department(department){
    const { id } = department;
    if(id){
      return post(`/api/v1/departments/${id}`, {department: department})
    }
    return post(`/api/v1/departments`, {department: department})
  }

  getDepartmentsByPrograms(params = null){
    if(params === null)
      return get(`/api/v1/program_departments`)

    return get(`/api/v1/program_departments?${params}`)
  }



}
