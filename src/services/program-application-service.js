import { get, post, put } from '../utils';
export class ProgramApplicationService {
  getProgramApplications(params = null) {
    if (params) return get(`/api/v1/program_applications?${params}`);
    return get(`/api/v1/program_applications`);
  }
  getProgramApplicationById(id) {
    return new Promise((reject) => {
      if (!id) reject("Program application id not specified")
      return get(`/api/v1/program_applications/${params}`);
    })
  }
  saveProgramApplication(program_application) {
    return new Promise((reject) => {
      if (!program_application) reject("Parameter not specified");
      const { id } = program_application
      const data = { program_application: program_application };
      if (id) return put(`/api/v1/program_applications/${id}`, data);
      return post(`/api/v1/program_applications`, data);
    })
  }
}
