import { get, post, put} from '../utils';
export class LevelService {
  getLevels(params = null){
    if(params){
      return get(`/api/v1/levels?${params}`)
    }
    return get(`/api/v1/levels`)
  }
  getLevelById(id){
    return get(`/api/v1/levels/${id}`)
  }
  saveLevel(level){
    const { id } = level;
    if(id){
      return post(`/api/v1/levels/${id}`, {level: level})
    }
    return post(`/api/v1/levels`, {level: level})
  }

}
