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
      total_units: student_result.total_units,
      total_score: student_result.total_score,
      total_point_average: student_result.total_point_average,
      number_passed: student_result.number_passed,
      number_failed: student_result.number_failed,
      promoted: student_result.promoted}
  end
end
