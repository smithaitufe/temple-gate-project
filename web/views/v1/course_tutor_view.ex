defmodule PortalApi.V1.CourseTutorView do
  use PortalApi.Web, :view

  def render("index.json", %{course_tutors: course_tutors}) do
    render_many(course_tutors, PortalApi.V1.CourseTutorView, "course_tutor.json")
  end

  def render("show.json", %{course_tutor: course_tutor}) do
    render_one(course_tutor, PortalApi.V1.CourseTutorView, "course_tutor.json")
  end

  def render("course_tutor.json", %{course_tutor: course_tutor}) do
    %{id: course_tutor.id,
      course_id: course_tutor.course_id,
      staff_id: course_tutor.staff_id,
      academic_session_id: course_tutor.academic_session_id}
  end
end
