defmodule PortalApi.V1.StudentCourseAssessmentView do
  use PortalApi.Web, :view

  def render("index.json", %{student_course_assessments: student_course_assessments}) do
    render_many(student_course_assessments, PortalApi.V1.StudentCourseAssessmentView, "student_course_assessment.json")
  end

  def render("show.json", %{student_course_assessment: student_course_assessment}) do
    render_one(student_course_assessment, PortalApi.V1.StudentCourseAssessmentView, "student_course_assessment.json")
  end

  def render("student_course_assessment.json", %{student_course_assessment: student_course_assessment}) do
    %{
      id: student_course_assessment.id,
      student_course_id: student_course_assessment.student_course_id,
      staff_id: student_course_assessment.staff_id,
      assessment_type_id: student_course_assessment.assessment_type_id,
      score: student_course_assessment.score,
      inserted_at: student_course_assessment.inserted_at
    }
    |> Map.put(:assessment_type, render_one(student_course_assessment.assessment_type, PortalApi.V1.TermView, "term.json"))
  end
end
