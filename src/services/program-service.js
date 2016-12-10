import { get, post, put} from '../utils';
export class ProgramService {
  get_programs(params = null){
    return get(`/api/v1/programs`)
  }
  
  getPrograms(params = null){
    return get(`/api/v1/programs`)
  }
  getProgramById(id){
    return get(`/api/v1/programs/${id}`)
  }
  
  get_program_by_id(id){
    return get(`/api/v1/programs/${id}`)
  }
  save_program(program){
    const { id } = program;
    if(id){
      return post(`/api/v1/programs/${id}`, {program: program})
    }
    return post(`/api/v1/programs`, {program: program})
  }

}
