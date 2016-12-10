import { get, post, put } from '../utils';
export class ProgramApplicationService {
    getProgramApplications(params = null){
        if(params)
            return get(`/api/v1/program_applications?${params}`);
        return get(`/api/v1/program_applications`);
    }
    getProgramApplicationById(id){
        if(id)
            return get(`/api/v1/program_applications/${params}`);
        throw new Error("Parameter not specified");        
    }
    saveProgramApplication(program_application){
        if(!program_application)
            throw new Error("Parameter not specified");

        const { id } = program_application
        const data = { program_application: program_application};
        if(id){
            return put(`/api/v1/program_applications/${id}`, data);
        }

        return post(`/api/v1/program_applications`, data);
    }
}