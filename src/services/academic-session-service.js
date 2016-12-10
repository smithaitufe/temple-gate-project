import { get, post, put } from '../utils'
import moment from 'moment';
export class AcademicSessionService {
  get_academic_sessions(params = null){
    if(params){
      return get(`/api/v1/academic_sessions?${params}`)
    }
    return get(`/api/v1/academic_sessions`)
  }

  get_academic_session_by_id(id){
    return get(`/api/v1/academic_sessions/${id}`)
  }
  save_academic_session(academic_session){
    const { id } = academic_session;
    if(id){
      return put(`/api/v1/academic_sessions/${id}`, {academic_session: academic_session})
    }
    return post(`/api/v1/academic_sessions`, {academic_session: academic_session})
  }

}
