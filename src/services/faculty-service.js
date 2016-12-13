import { get, post, put } from '../utils';
export class FacultyService {
  getFaculties(params = null) {
    if (params) return get(`/api/v1/faculties?${params}`)
    return get(`/api/v1/faculties`)
  }
  getFacultyById(id) {
    return new Promise((reject) => {
      if (!id) reject("Parameter not specified")
      return get(`/api/v1/faculties/${id}`)
    })
  }
  saveFaculty(faculty) {
    return new Promise((reject) => {
      if (!faculty) reject("Parameter not specified")
      const { id } = faculty;
      const data = { faculty: faculty };
      if (id) return post(`/api/v1/faculties/${id}`, data)
      return post(`/api/v1/faculties`, data)
    })
  }

}
