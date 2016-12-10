import { get, post, put } from '../utils';

export class CourseRegistrationSettingService {
 get_registration_settings(params = null){
    if(params){
      return get(`/api/v1/course_registration_settings?${params}`)
    }
    return get(`/api/v1/course_registration_settings`)
  }
  save_registration_setting(course_registration_setting){
    const { id } = course_registration_setting;
    const data = { course_registration_setting: course_registration_setting };

    if(id){
      return put(`/api/v1/course_registration_settings/${id}`, data)
    }
    return post(`/api/v1/course_registration_settings/`, data)
  }
}
