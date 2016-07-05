defmodule PortalApi.V1.StudentResultGradeView do
  use PortalApi.Web, :view

  def render("index.json", %{student_result_grades: student_result_grades}) do
    %{data: render_many(student_result_grades, PortalApi.V1.StudentResultGradeView, "student_result_grade.json")}
  end

  def render("show.json", %{student_result_grade: student_result_grade}) do
    %{data: render_one(student_result_grade, PortalApi.V1.StudentResultGradeView, "student_result_grade.json")}
  end

  def render("student_result_grade.json", %{student_result_grade: student_result_grade}) do
    %{id: student_result_grade.id,
      student_result_id: student_result_grade.student_result_id,
      course_id: student_result_grade.course_id,
      score: student_result_grade.score,
      grade_id: student_result_grade.grade_id
      }
  end
end
