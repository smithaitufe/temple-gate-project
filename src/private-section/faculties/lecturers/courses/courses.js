import { inject } from 'aurelia-framework';
import { User } from '../../../user';
import { AcademicSessionService, ProgramService, CourseService } from '../../../../services';

@inject(User, AcademicSessionService, ProgramService, CourseService)
export class Courses {
  courses = [];
  programs = [];
  academic_sessions = [];
  constructor(user, academicSessionService, programService, courseService){
    this.user = user;
    this.academicSessionService = academicSessionService;
    this.programService = programService;
    this.courseService = courseService;
  }
  async activate(){    
    // let responses = Promise.all([
    //   this.academicSessionService.getAcademicSessions(`order_by_desc=id`),
    //   this.programService.getPrograms()
    // ]);
    // this.academic_sessions = responses[0];
    // this.programs = responses[1];    

    // Promise.all([
    //   this.academicSessionService.getAcademicSessions(`order_by_desc=id`),
    //   this.programService.getPrograms()
    // ]).then((responses) => {
    //   this.academic_sessions = responses[0];
    //   this.programs = responses[1];    
    // });
  }
  fetchCourses(){
    let query = `tutor_user_id=${this.user.id}`;
    this.courseService.getAssignedCourses(query).then(response => {
      this.courses = response;
    })
  }
}
