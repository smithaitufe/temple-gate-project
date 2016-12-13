import { get, post, put} from '../utils';
export class ProgramService {
  getPrograms(params = null){
    if(params) return get(`/api/v1/programs?${params}`);
    return get(`/api/v1/programs`)
  }
  getProgramById(id){
    return new Promise((reject) => {
      if(!id) reject("Program id not specified");
      return get(`/api/v1/programs/${id}`)
    });    
  }
  saveProgram(program){
    return new Promise((reject) => {
      if (!program) reject("Program parameter not specified");
      const { id } = program;
      if (id) return post(`/api/v1/programs/${id}`, { program: program })
      return post(`/api/v1/programs`, { program: program })
    });
  }

}
