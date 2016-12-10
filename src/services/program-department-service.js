import { get, post, put} from '../utils';
export class ProgramDepartmentService {
  get_departments(params = null){
    return get(`/api/v1/departments`)
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
  saveDepartment(){
    
  }


}
