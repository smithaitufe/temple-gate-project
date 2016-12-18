import { inject } from 'aurelia-framework';
import { User } from '../../user';
import { CourseService } from '../../../services';

@inject(User, CourseService)
export class Course {
  constructor(user, courseService){
    this.user = user;
    this.courseService = courseService;
  }

  activate(params){
    const { course_id, enrollment_id } = params;
    const { id, program, department, academic_session } = this.user;
    // this.courseService.getEnrolledCourses(`user_id=${id}&course_id=${course_id}`).then(response => {
    //   this.enrollment = response[0];
    // });

    this.courseService.getEnrolledCourseById(enrollment_id).then(response => {      
      const { course, course_grade, assessments } = response;
      this.course = course;
      this.course_grade = course_grade;
      this.assessments = assessments;
    });
  }
  get getTotal(){
    if(this.assessments) return this.assessments.reduce((prev, assessment) => assessment.score + prev,0);
  }

}
