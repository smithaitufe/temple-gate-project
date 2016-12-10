import { get, post, put } from '../utils';

export class DirectEntryQualificationService{
    getDirectEntryQualifications(params = null){
        if(params)
            return get(`/api/v1/direct_entry_qualifications?${params}`);
        return get(`/api/v1/direct_entry_qualifications`);
    }
    getDirectEntryQualificationById(id){
        if(!id)
            throw new Error("Parameter not defined")
        return get(`/api/v1/direct_entry_qualifications/${id}`);
    }
    saveDirectEntryQualification(params){
        if(!params)
            throw new Error("Object parameters not defined");

        const data = {direct_entry_qualification: params};
        const { id } = params;
        if(id)
            return put(`/api/v1/direct_entry_qualifications/${id}`, data);
        return post(`/api/v1/direct_entry_qualifications`, data);
    }

}


export class JambRecordService{
    getJambRecords(params = null){
        if(params)
            return get(`/api/v1/jamb_records?${params}`);
        return get(`/api/v1/jamb_records`);
    }
    getJambRecordById(id){
        if(!id)
            throw new Error("Parameter not defined")
        return get(`/api/v1/jamb_records/${id}`);
    }
    saveJambRecord(params){
        if(!params)
            throw new Error("Object parameters not defined");
            
        const data = {jamb_record: params};
        const { id } = params;
        if(id)
            return put(`/api/v1/jamb_records/${id}`, data);
        return post(`/api/v1/jamb_records`, data);
    }

}

