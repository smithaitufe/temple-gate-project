import { get, post, put } from '../utils'
import moment from 'moment';
export class AcademicSessionService {
  getAcademicSessions(params){
    if(params){
      return get(`/api/v1/academic_sessions?${params}`)
    }
    return get(`/api/v1/academic_sessions`)
  }

  getAcademicSessionById(id){
    if(!id) throw new Error("Parameter not specified");
    return get(`/api/v1/academic_sessions/${id}`)
  }
  saveAcademicSession(academicSession){
    return new Promise(reject => {
      if(!academicSession) reject();
      const { id } = academicSession;
      const data = { academic_session: academicSession};
      if(id) return put(`/api/v1/payment_splits/${id}`, data);
      return post(`api/v1/payment_splits`, data);      
    });    
  }

}
