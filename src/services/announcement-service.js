import { get, post, put } from '../utils';

export class AnnouncementService{
  get_news(params = null){
    if(params){
      return get(`/api/v1/announcements?${params}`)
    }
    return get(`/api/v1/announcements`);
  }
  getAnnouncements(params = null){
    if(params){
      return get(`/api/v1/announcements?${params}`)
    }
    return get(`/api/v1/announcements`);
  }

}
