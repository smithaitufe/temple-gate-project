defmodule PortalApi.V1.StudentCertificateView do
  use PortalApi.Web, :view

  def render("index.json", %{student_certificates: student_certificates}) do
    render_many(student_certificates, PortalApi.V1.StudentCertificateView, "student_certificate.json")
  end

  def render("show.json", %{student_certificate: student_certificate}) do
    render_one(student_certificate, PortalApi.V1.StudentCertificateView, "student_certificate.json")
  end

  def render("student_certificate.json", %{student_certificate: student_certificate}) do
    %{id: student_certificate.id,
      student_id: student_certificate.student_id,
      examination_body_id: student_certificate.examination_body_id,
      year_obtained: student_certificate.year_obtained,
      registration_no: student_certificate.registration_no}
  end
end
