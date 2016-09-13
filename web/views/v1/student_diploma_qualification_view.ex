defmodule PortalApi.V1.StudentDiplomaQualificationView do
  use PortalApi.Web, :view

  def render("index.json", %{student_diploma_qualifications: student_diploma_qualifications}) do
    render_many(student_diploma_qualifications, PortalApi.V1.StudentDiplomaQualificationView, "student_diploma_qualification.json")
  end

  def render("show.json", %{student_diploma_qualification: student_diploma_qualification}) do
    render_one(student_diploma_qualification, PortalApi.V1.StudentDiplomaQualificationView, "student_diploma_qualification.json")
  end

  def render("student_diploma_qualification.json", %{student_diploma_qualification: student_diploma_qualification}) do
    %{id: student_diploma_qualification.id,
      student_id: student_diploma_qualification.student_id,
      school: student_diploma_qualification.school,
      course: student_diploma_qualification.course,
      cgpa: student_diploma_qualification.cgpa,
      year_admitted: student_diploma_qualification.year_admitted,
      year_graduated: student_diploma_qualification.year_graduated}
  end
end
