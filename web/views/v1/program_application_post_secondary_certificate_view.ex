defmodule PortalApi.V1.ProgramApplicationPostSecondaryCertificateView do
  use PortalApi.Web, :view

  def render("index.json", %{program_application_post_secondary_certificates: program_application_post_secondary_certificates}) do
    render_many(program_application_post_secondary_certificates, PortalApi.V1.ProgramApplicationPostSecondaryCertificateView, "program_application_post_secondary_certificate.json")
  end

  def render("show.json", %{program_application_post_secondary_certificate: program_application_post_secondary_certificate}) do
    render_one(program_application_post_secondary_certificate, PortalApi.V1.ProgramApplicationPostSecondaryCertificateView, "program_application_post_secondary_certificate.json")
  end

  def render("program_application_post_secondary_certificate.json", %{program_application_post_secondary_certificate: program_application_post_secondary_certificate}) do
    %{
      program_application_id: program_application_post_secondary_certificate.program_application_id,
      post_secondary_certificate_id: program_application_post_secondary_certificate.post_secondary_certificate_id
    }
  end
end
