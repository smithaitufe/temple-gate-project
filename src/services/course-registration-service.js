import { get, post, put } from '../utils'
import moment from 'moment';
export class CourseRegistrationSettingService {
  get_course_registration_settings(params = null){
    if(params){
      return get(`/api/v1/course_registration_settings?${params}`)
    }
    return get(`/api/v1/course_registration_settings`)
  }
  get_course_registration_setting_by_id(id){
    return get(`/api/v1/course_registration_settings/${id}`)
  }
  save_course_registration_setting(course_registration_setting){
    const { id } = course_registration_setting;
    if(id){
      return put(`/api/v1/course_registration_settings/${id}`, {course_registration_setting: course_registration_setting})
    }
    return post(`/api/v1/course_registration_settings`, {course_registration_setting: course_registration_setting})
  }
  is_course_registration_allowed(closing_date){
    let current_date = new Date();
    return moment(current_date).isBefore(closing_date)
  }

}
