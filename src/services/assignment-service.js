import { get, post, put } from '../utils';

export class AssignmentService {
  getAssignments(params = null) {
    if (params) { return get(`/api/v1/assignments/${params}`) }
    return get(`/api/v1/assignments`)
  }
  getAssignment(id) {
    if (id) {
      return get(`/api/v1/assignments/${id}`)
    }
    throw new Error("Assignment Id not specified")
  }
  saveAssignment(assignment) {
    return new Promise((reject) => {
      if (!assignment) reject("Assignment parameter not specified");
      const { id } = assignment;
      const data = { assignment: assignment }
      if (id) { return put(`/api/v1/assignments/${id}`, data) }
      return post(`/api/v1/assignments/`, data)
    });
  }

}
