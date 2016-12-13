import { get, post, put } from '../utils';
import moment from 'moment';

export class CourseRegistrationSettingService {
  getCourseRegistrationSettings(params) {
    if(params) {
      return get(`/api/v1/course_registration_settings?${params}`)
    }
    return get(`/api/v1/course_registration_settings`)
  }
  saveCourseRegistrationSetting(courseRegistrationSetting) {
    return new Promise(reject => {
      if(!courseRegistrationSetting) reject("Course registration setting parameter not specified");
      const { id } = courseRegistrationSetting;
      const data = { course_registration_setting: courseRegistrationSetting };
      if (id) {
        return put(`/api/v1/course_registration_settings/${id}`, data)
      }
      return post(`/api/v1/course_registration_settings/`, data)
    });
  }
  isRegistrationAllowed(closingDate) {
    return moment(new Date()).isBefore(closingDate)
  }

}
