defmodule PortalApi.V1.StudentContinuousAssessmentView do
  use PortalApi.Web, :view

  def render("index.json", %{student_continuous_assessments: student_continuous_assessments}) do
    render_many(student_continuous_assessments, PortalApi.V1.StudentContinuousAssessmentView, "student_continuous_assessment.json")
  end

  def render("show.json", %{student_continuous_assessment: student_continuous_assessment}) do
    render_one(student_continuous_assessment, PortalApi.V1.StudentContinuousAssessmentView, "student_continuous_assessment.json")
  end

  def render("student_continuous_assessment.json", %{student_continuous_assessment: student_continuous_assessment}) do
    %{
      id: student_continuous_assessment.id,
      course_id: student_continuous_assessment.course_id,
      staff_id: student_continuous_assessment.staff_id,
      student_id: student_continuous_assessment.student_id,
      continuous_assessment_type_id: student_continuous_assessment.continuous_assessment_type_id,
      score: student_continuous_assessment.score
    }
  end
end
