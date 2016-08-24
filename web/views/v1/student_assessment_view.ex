defmodule PortalApi.V1.StudentAssessmentView do
  use PortalApi.Web, :view

  def render("index.json", %{student_assessments: student_assessments}) do
    render_many(student_assessments, PortalApi.V1.StudentAssessmentView, "student_assessment.json")
  end

  def render("show.json", %{student_assessment: student_assessment}) do
    render_one(student_assessment, PortalApi.V1.StudentAssessmentView, "student_assessment.json")
  end

  def render("student_assessment.json", %{student_assessment: student_assessment}) do
    %{
      id: student_assessment.id,
      student_course_id: student_assessment.student_course_id,
      staff_id: student_assessment.staff_id,
      continuous_assessment_type_id: student_assessment.continuous_assessment_type_id,
      score: student_assessment.score,

    }
  end
end
