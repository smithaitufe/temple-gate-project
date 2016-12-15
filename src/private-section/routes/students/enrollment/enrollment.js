import { inject } from 'aurelia-framework';
import { User } from '../../../user';
import { CourseService, AcademicSessionService, CourseRegistrationSettingService } from '../../../../services';


@inject(User, CourseService, AcademicSessionService, CourseRegistrationSettingService)
export class Enrollment {

  courses = [];
  selected_courses = [];
  academic_session = {};
  course_registration_setting = {};
  
  constructor(user, courseService, academicSessionService, courseRegistrationSettingService) {
    this.user = user;
    this.courseService = courseService;
    this.academicSessionService = academicSessionService;
    this.courseRegistrationSettingService = courseRegistrationSettingService;
  }
  activate() {
    this.academicSessionService.getAcademicSessions(`active=true`).then(response => {
      this.academic_session = Object.assign({}, this.academic_session, {...response[0]});      
      this.courseRegistrationSettingService.getCourseRegistrationSettings(`academic_session_id=${this.academic_session.id}`).then(response => {
        this.course_registration_setting = Object.assign({}, this.course_registration_setting, {...response[0]});
          this.registration_allowed = this.courseRegistrationSettingService.isRegistrationAllowed(this.course_registration_setting.closing_date);
          if(!this.registration_allowed){
            const { department, level } = this.user;
            this.fetchCourses(department.id, level.id).then(() => {
              first_semester_courses = {core: [], general: [], elective: []};
              second_semester_courses = {core: [], general: [], elective: []};
              console.log(this.courses);

              // this.courses.forEach(course => {
              //   if(course.semester.description == "1st"){
              //     first_semester_courses.core = this.groupCourses(course, "core");
              //   }
              // })
            });
          }
        
      });
    });
    
  }
  fetchCourses(department_id, level_id){
    let params = `department_id=${department_id}&level_id=${level_id}`;
    return this.courseService.getCourses(params).then(response => {
      this.courses = [...response];
    });
  }
  groupCourses(courses, type){
    return courses.filter(course=> course.course_category.description.indexOf(type) > -1);
  }
  enroll(){
    console.log(this.selected_courses);
  }
}
