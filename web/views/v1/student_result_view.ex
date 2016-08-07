defmodule PortalApi.V1.StudentResultView do
  use PortalApi.Web, :view

  def render("index.json", %{student_results: student_results}) do
    render_many(student_results, PortalApi.V1.StudentResultView, "student_result.json")
  end

  def render("show.json", %{student_result: student_result}) do
    render_one(student_result, PortalApi.V1.StudentResultView, "student_result.json")
  end

  def render("student_result.json", %{student_result: student_result}) do
    %{id: student_result.id,
      academic_session_id: student_result.academic_session_id,
      student_id: student_result.student_id,
      level_id: student_result.level_id,
      semester_id: student_result.semester_id,
      course_id: student_result_item.course_id,
      score: student_result_item.score,
      grade_id: student_result_item.grade_id
      }
  end
end
