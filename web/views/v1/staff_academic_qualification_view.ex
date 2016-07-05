defmodule PortalApi.V1.StaffAcademicQualificationView do
  use PortalApi.Web, :view

  def render("index.json", %{staff_academic_qualifications: staff_academic_qualifications}) do
    %{data: render_many(staff_academic_qualifications, PortalApi.V1.StaffAcademicQualificationView, "staff_academic_qualification.json")}
  end

  def render("show.json", %{staff_academic_qualification: staff_academic_qualification}) do
    %{data: render_one(staff_academic_qualification, PortalApi.V1.StaffAcademicQualificationView, "staff_academic_qualification.json")}
  end

  def render("staff_academic_qualification.json", %{staff_academic_qualification: staff_academic_qualification}) do
    %{id: staff_academic_qualification.id,
      staff_id: staff_academic_qualification.staff_id,
      certificate_id: staff_academic_qualification.certificate_id,
      school: staff_academic_qualification.school,
      course_studied: staff_academic_qualification.course_studied,
      from: staff_academic_qualification.from,
      to: staff_academic_qualification.to}
  end
end
