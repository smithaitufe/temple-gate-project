defmodule PortalApi.V1.CourseTutorView do
  use PortalApi.Web, :view

  def render("index.json", %{course_tutors: course_tutors}) do
    render_many(course_tutors, PortalApi.V1.CourseTutorView, "course_tutor.json")
  end

  def render("show.json", %{course_tutor: course_tutor}) do
    render_one(course_tutor, PortalApi.V1.CourseTutorView, "course_tutor.json")
  end

  def render("course_tutor.json", %{course_tutor: course_tutor}) do
    %{
      id: course_tutor.id,
      course_id: course_tutor.course_id,
      tutor_user_id: course_tutor.tutor_user_id,
      assigned_by_user_id: course_tutor.assigned_by_user_id,
      academic_session_id: course_tutor.academic_session_id,
      grades_submitted: course_tutor.grades_submitted,
      grades_submitted_at: course_tutor.grades_submitted_at
    }
    |> Map.put(:course, render_one(course_tutor.course, PortalApi.V1.CourseView, "course_lite.json"))
    |> Map.put(:tutor, render_one(course_tutor.tutor, PortalApi.V1.UserView, "user.json"))
    |> Map.put(:assigned_by, render_one(course_tutor.assigned_by, PortalApi.V1.UserView, "user.json"))
    |> Map.put(:academic_session, render_one(course_tutor.academic_session, PortalApi.V1.AcademicSessionView, "academic_session.json"))
  end
end
