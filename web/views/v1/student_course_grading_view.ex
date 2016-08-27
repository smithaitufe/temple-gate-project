defmodule PortalApi.V1.StudentCourseGradingView do
  use PortalApi.Web, :view

  def render("index.json", %{student_course_gradings: student_course_gradings}) do
    render_many(student_course_gradings, PortalApi.V1.StudentCourseGradingView, "student_course_grading.json")
  end

  def render("show.json", %{student_course_grading: student_course_grading}) do
    render_one(student_course_grading, PortalApi.V1.StudentCourseGradingView, "student_course_grading.json")
  end

  def render("student_course_grading.json", %{student_course_grading: student_course_grading}) do
    %{id: student_course_grading.id,
      student_course_id: student_course_grading.student_course_id,
      score: student_course_grading.score,
      letter: student_course_grading.letter,
      weight: student_course_grading.weight,
      grade_point: student_course_grading.grade_point,
      grade_id: student_course_grading.grade_id,
      uploaded_by_staff_id: student_course_grading.uploaded_by_staff_id,
      edited_by_staff_id: student_course_grading.edited_by_staff_id}
  end
end
