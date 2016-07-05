defmodule PortalApi.V1.CourseEnrollmentView do
  use PortalApi.Web, :view

  def render("index.json", %{course_enrollments: course_enrollments}) do
    %{data: render_many(course_enrollments, PortalApi.V1.CourseEnrollmentView, "course_enrollment.json")}
  end

  def render("show.json", %{course_enrollment: course_enrollment}) do
    %{data: render_one(course_enrollment, PortalApi.V1.CourseEnrollmentView, "course_enrollment.json")}
  end

  def render("course_enrollment.json", %{course_enrollment: course_enrollment}) do
    %{id: course_enrollment.id,
      course_id: course_enrollment.course_id,
      student_id: course_enrollment.student_id,
      academic_session_id: course_enrollment.academic_session_id}
  end
end
