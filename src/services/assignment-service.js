import { get, post, put } from '../utils';

export class AssignmentService {
  get_assignments(params = null){
    if(params){}
    return get(`/api/v1/assignments`)
  }
  get_assignment(id){
    if(id){
      return get(`/api/v1/assignments/${id}`)
    }
    throw new Error("Assignment Id not specified")
  }
  save_assignment(assignment){
    const { id } = assignment;
    const data = { assignment: assignment }
    if(id){ return put(`/api/v1/assignments/${id}`, data)}
    return post(`/api/v1/assignments/`, data)
  }


}
