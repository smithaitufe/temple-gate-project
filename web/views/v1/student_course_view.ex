defmodule PortalApi.V1.StudentCourseView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{StudentCourseView, StudentView, CourseView}

  def render("index.json", %{student_courses: student_courses}) do
    render_many(student_courses, StudentCourseView, "student_course.json")
  end

  def render("show.json", %{student_course: student_course}) do
    render_one(student_course, StudentCourseView, "student_course.json")
  end

  def render("student_course.json", %{student_course: student_course}) do
    %{id: student_course.id,
      course_id: student_course.course_id,
      student_id: student_course.student_id,
      academic_session_id: student_course.academic_session_id
    }
    |> StudentView.render_student(%{student: student_course.student})
    |> CourseView.render_course(%{course: student_course.course})
  end





end
