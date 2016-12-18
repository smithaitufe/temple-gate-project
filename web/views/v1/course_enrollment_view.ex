defmodule PortalApi.V1.CourseEnrollmentView do
  use     PortalApi.Web, :view
  alias   PortalApi.V1.{CourseEnrollmentView, UserView, CourseView, CourseGradingView, CourseEnrollmentAssessmentView, AcademicSessionView}

  def render("index.json", %{course_enrollments: course_enrollments}) do
    render_many(course_enrollments, CourseEnrollmentView, "course_enrollment.json")
  end

  def render("show.json", %{course_enrollment: course_enrollment}) do
    render_one(course_enrollment, CourseEnrollmentView, "course_enrollment.json")
  end

  def render("course_enrollment.json", %{course_enrollment: course_enrollment}) do
    %{
      id: course_enrollment.id,
      course_id: course_enrollment.course_id,
      user_id: course_enrollment.user_id,
      academic_session_id: course_enrollment.academic_session_id,
      graded: course_enrollment.graded
      }
    |> Map.put(:user, render_one(course_enrollment.user, UserView, "user.json"))
    |> Map.put(:academic_session, render_one(course_enrollment.academic_session, AcademicSessionView, "academic_session.json"))
    |> Map.put(:course, render_one(course_enrollment.course, CourseView, "course.json"))
    |> Map.put(:course_grade, render_one(course_enrollment.course_grading, StudentCourseGradingView, "course_enrollment_grading.json"))
    |> Map.put(:assessments, render_many(course_enrollment.assessments, CourseEnrollmentAssessmentView, "course_enrollment_assessment.json"))
  end





end
