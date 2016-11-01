defmodule PortalApi.V1.DirectEntryQualificationView do
  use PortalApi.Web, :view

  def render("index.json", %{direct_entry_qualifications: direct_entry_qualifications}) do
    %{data: render_many(direct_entry_qualifications, PortalApi.V1.StudentDirectEntryQualificationView, "direct_entry_qualification.json")}
  end

  def render("show.json", %{direct_entry_qualification: direct_entry_qualification}) do
    %{data: render_one(direct_entry_qualification, PortalApi.V1.StudentDirectEntryQualificationView, "direct_entry_qualification.json")}
  end

  def render("direct_entry_qualification.json", %{direct_entry_qualification: direct_entry_qualification}) do
    %{id: direct_entry_qualification.id,
      entered_by_user_id: direct_entry_qualification.entered_by_user_id,
      school: direct_entry_qualification.school,
      course_studied: direct_entry_qualification.course_studied,
      cgpa: direct_entry_qualification.cgpa,
      year_admitted: direct_entry_qualification.year_admitted,
      year_graduated: direct_entry_qualification.year_graduated,
      verified: direct_entry_qualification.verified,
      verified_by_user_id: direct_entry_qualification.verified_by_user_id,
      verified_at: direct_entry_qualification.verified_at}
  end
end
