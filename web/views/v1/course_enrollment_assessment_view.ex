defmodule PortalApi.V1.CourseEnrollmentAssessmentView do
  use PortalApi.Web, :view

  def render("index.json", %{course_enrollment_assessments: course_enrollment_assessments}) do
    render_many(course_enrollment_assessments, PortalApi.V1.CourseEnrollmentAssessmentView, "course_enrollment_assessment.json")
  end

  def render("show.json", %{course_enrollment_assessment: course_enrollment_assessment}) do
    render_one(course_enrollment_assessment, PortalApi.V1.CourseEnrollmentAssessmentView, "course_enrollment_assessment.json")
  end

  def render("course_enrollment_assessment.json", %{course_enrollment_assessment: course_enrollment_assessment}) do
    %{
      id: course_enrollment_assessment.id,
      course_enrollment_id: course_enrollment_assessment.course_enrollment_id,
      assessed_by_user_id: course_enrollment_assessment.assessed_by_user_id,
      assessment_type_id: course_enrollment_assessment.assessment_type_id,
      score: course_enrollment_assessment.score,
      inserted_at: course_enrollment_assessment.inserted_at
    }
    |> Map.put(:assessment_type, render_one(course_enrollment_assessment.assessment_type, PortalApi.V1.TermView, "term.json"))
  end
end
