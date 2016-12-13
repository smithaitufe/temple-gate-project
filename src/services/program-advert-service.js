import moment from 'moment';
import { get, post, put} from '../utils';

export class ProgramAdvertService {
  getProgramAdverts(params = null){
    if(params){
      return get(`/api/v1/program_adverts?${params}`)
    }
    return get(`/api/v1/program_adverts`)
  }
  getProgramAdvertById(id){
    if(!id){
      throw new Error("Parameter not specified");
    }
    return get(`/api/v1/program_adverts/${id}`)
  }
  saveProgramAdvert(programAdvert = null){
    return new Promise((reject) => {
      if(!programAdvert) reject("Program advert not specified");
      const { id } = programAdvert;
      const data = {program_advert: programAdvert}
      if(id){
        return put(`/api/v1/program_adverts/${id}`, data)
      }
      return post(`/api/v1/program_adverts`, data)
    });   
    
  }
  isAdmitting(closingDate){
    let currentDate = new Date();
    return moment(currentDate).isBefore(closingDate)
  }


}
