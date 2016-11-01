defmodule PortalApi.V1.DiplomaQualificationView do
  use PortalApi.Web, :view

  def render("index.json", %{diploma_qualifications: diploma_qualifications}) do
    render_many(diploma_qualifications, PortalApi.V1.DiplomaQualificationView, "diploma_qualification.json")
  end

  def render("show.json", %{diploma_qualification: diploma_qualification}) do
    render_one(diploma_qualification, PortalApi.V1.DiplomaQualificationView, "diploma_qualification.json")
  end

  def render("diploma_qualification.json", %{diploma_qualification: diploma_qualification}) do
    %{id: diploma_qualification.id,
      user_id: diploma_qualification.user_id,
      school: diploma_qualification.school,
      course: diploma_qualification.course,
      cgpa: diploma_qualification.cgpa,
      year_admitted: diploma_qualification.year_admitted,
      year_graduated: diploma_qualification.year_graduated}
  end
end
