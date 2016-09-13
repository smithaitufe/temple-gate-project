defmodule PortalApi.V1.StudentDirectEntryQualificationView do
  use PortalApi.Web, :view

  def render("index.json", %{student_direct_entry_qualifications: student_direct_entry_qualifications}) do
    %{data: render_many(student_direct_entry_qualifications, PortalApi.V1.StudentDirectEntryQualificationView, "student_direct_entry_qualification.json")}
  end

  def render("show.json", %{student_direct_entry_qualification: student_direct_entry_qualification}) do
    %{data: render_one(student_direct_entry_qualification, PortalApi.V1.StudentDirectEntryQualificationView, "student_direct_entry_qualification.json")}
  end

  def render("student_direct_entry_qualification.json", %{student_direct_entry_qualification: student_direct_entry_qualification}) do
    %{id: student_direct_entry_qualification.id,
      student_id: student_direct_entry_qualification.student_id,
      school: student_direct_entry_qualification.school,
      course_studied: student_direct_entry_qualification.course_studied,
      cgpa: student_direct_entry_qualification.cgpa,
      year_admitted: student_direct_entry_qualification.year_admitted,
      year_graduated: student_direct_entry_qualification.year_graduated,
      verified: student_direct_entry_qualification.verified,
      verified_by_staff_id: student_direct_entry_qualification.verified_by_staff_id,
      verified_at: student_direct_entry_qualification.verified_at}
  end
end
