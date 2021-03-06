import { inject } from 'aurelia-framework';
import { Router } from 'aurelia-router';
import { User } from '../../user';
import { AcademicSessionService, CourseService } from '../../../services';

@inject(Router, User, AcademicSessionService, CourseService)
export class Courses{
  enrollments = [];
  academic_sessions = [];
  academic_session;

  constructor(router, user, academicSessionService, courseService){
    this.router = router;
    this.user = user;
    this.academicSessionService = academicSessionService;
    this.courseService = courseService;
  }
  activate(){
    this.academicSessionService.getAcademicSessions(`order_by_desc=id`).then(response => {
      this.academic_sessions = response;
    });    
  }
  fetchCourses(){
    const { id, department } = this.user;
    let params = `user_id=${id}&department_id=${department.id}&academic_session_id=${this.academic_session.id}`;

    this.courseService.getEnrolledCourses(params).then(response => {
      this.enrollments = response;
    });
  }
  open(id){
    this.router.navigateToRoute("course", {enrollment_id: id});
  }
}
