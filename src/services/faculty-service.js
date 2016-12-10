import { get, post, put} from '../utils';
export class FacultyService {
  get_faculties(params = null){
    return get(`/api/v1/faculties`)
  }
  get_faculty_by_id(id){
    return get(`/api/v1/faculties/${id}`)
  }
  save_faculty(faculty){
    const { id } = faculty;
    if(id){
      return post(`/api/v1/faculties/${id}`, {faculty: faculty})
    }
    return post(`/api/v1/faculties`, {faculty: faculty})
  }

}
