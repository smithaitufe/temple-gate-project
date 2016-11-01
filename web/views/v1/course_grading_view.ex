defmodule PortalApi.V1.CourseGradingView do
  use PortalApi.Web, :view

  def render("index.json", %{course_gradings: course_gradings}) do
    render_many(course_gradings, PortalApi.V1.CourseGradingView, "course_grading.json")
  end

  def render("show.json", %{course_grading: course_grading}) do
    render_one(course_grading, PortalApi.V1.CourseGradingView, "course_grading.json")
  end

  def render("course_grading.json", %{course_grading: course_grading}) do
    %{
      id: course_grading.id,
      course_enrollment_id: course_grading.course_enrollment_id,
      score: course_grading.score,
      letter: course_grading.letter,
      weight: course_grading.weight,
      grade_point: course_grading.grade_point,
      grade_id: course_grading.grade_id,
      uploaded_by_user_id: course_grading.uploaded_by_user_id,
      modified_by_user_id: course_grading.modified_by_user_id
    }
  end
end
