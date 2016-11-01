defmodule PortalApi.V1.CertificateView do
  use PortalApi.Web, :view

  def render("index.json", %{certificates: certificates}) do
    render_many(certificates, PortalApi.V1.CertificateView, "certificate.json")
  end

  def render("show.json", %{certificate: certificate}) do
    render_one(certificate, PortalApi.V1.CertificateView, "certificate.json")
  end

  def render("certificate.json", %{certificate: certificate}) do
    %{id: certificate.id,
      user_id: certificate.user_id,
      examination_body_id: certificate.examination_body_id,
      year_obtained: certificate.year_obtained,
      registration_no: certificate.registration_no}
  end
end
