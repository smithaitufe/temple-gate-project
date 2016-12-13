import { get, post, put } from '../utils';

export class DirectEntryQualificationService {
  getDirectEntryQualifications(params = null) {
    if (params)
      return get(`/api/v1/direct_entry_qualifications?${params}`);
    return get(`/api/v1/direct_entry_qualifications`);
  }
  getDirectEntryQualificationById(id) {
    if (!id)
      throw new Error("Parameter not defined")
    return get(`/api/v1/direct_entry_qualifications/${id}`);
  }
  saveDirectEntryQualification(params) {
    return new Promise((reject) => {
      if (!params) reject("Object parameters not defined");
      const data = { direct_entry_qualification: params };
      const { id } = params;
      if (id) return put(`/api/v1/direct_entry_qualifications/${id}`, data);
      return post(`/api/v1/direct_entry_qualifications`, data);
    });
  }

}


export class JambRecordService {
  getJambRecords(params = null) {
    if (params)
      return get(`/api/v1/jamb_records?${params}`);
    return get(`/api/v1/jamb_records`);
  }
  getJambRecordById(id) {
    return new Promise((reject) => {
      if (!id) reject("Parameter not specified");
      return get(`/api/v1/jamb_records/${id}`);
    })
  }
  saveJambRecord(params) {
    return new Promise((reject) => {
      if (!params) reject("Parameter not specified");
      const data = { jamb_record: params };
      const { id } = params;
      if (id) return put(`/api/v1/jamb_records/${id}`, data);
      return post(`/api/v1/jamb_records`, data);
    })

  }

}

