defmodule PortalApi.V1.AcademicQualificationView do
  use PortalApi.Web, :view

  def render("index.json", %{academic_qualifications: academic_qualifications}) do
    render_many(academic_qualifications, PortalApi.V1.AcademicQualificationView, "academic_qualification.json")
  end

  def render("show.json", %{academic_qualification: academic_qualification}) do
    render_one(academic_qualification, PortalApi.V1.AcademicQualificationView, "academic_qualification.json")
  end

  def render("academic_qualification.json", %{academic_qualification: academic_qualification}) do
    %{
      id: academic_qualification.id,
      user_id: academic_qualification.user_id,
      certificate_type_id: academic_qualification.certificate_type_id,
      school: academic_qualification.school,
      course_studied: academic_qualification.course_studied,
      from: academic_qualification.from,
      to: academic_qualification.to
    }
  end
end
