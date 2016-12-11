import { get, post, put } from '../utils';

export class AnnouncementService{  
  getAnnouncements(params){
    if(params){
      return get(`/api/v1/announcements?${params}`)
    }
    return get(`/api/v1/announcements`);
  }
  saveAnnouncement(announcement){
    return new Promise((reject) => {
      if(!announcement) reject("Parameter not specified");
      const { id } = announcement;
      const data = { announcement: announcement};
      if(id) return put(`/api/v1/announcements/${id}`, data)
      return post(`/api/v1/announcements`, data)
    });
  }

}
