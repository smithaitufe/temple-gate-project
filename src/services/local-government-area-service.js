import { get, post, put } from '../utils'
export class LocalGovernmentAreaService {
  getLocalGovernmentAreas(params = null) {
    if (params)
      return get(`/api/v1/local_government_areas?${params}`)
    return get(`/api/v1/local_government_areas`)
  }
  getLocalGovernmentAreaById(id) {
    if (!id)
      throw new Error("Parameter not specified");
    return get(`/api/v1/local_government_areas/${id}`);
  }
  saveLocalGovernmentArea(local_government_area) {
    return new Promise((reject) => {
      if(!local_government_area) reject("Local government area not specified");
      const data = { local_government_area: local_government_area };
      const { id } = local_government_area;
      if (id) {
        return put(`/api/v1/local_government_areas/${id}`, data)
      }
      return post(`/api/v1/local_government_areas`, data)
    });
  }
}
