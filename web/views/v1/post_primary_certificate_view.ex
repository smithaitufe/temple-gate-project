defmodule PortalApi.V1.PostPrimaryCertificateView do
  use PortalApi.Web, :view

  def render("index.json", %{post_primary_certificates: post_primary_certificates}) do
    render_many(post_primary_certificates, PortalApi.V1.PostPrimaryCertificateView, "post_primary_certificate.json")
  end

  def render("show.json", %{post_primary_certificate: post_primary_certificate}) do
    render_one(post_primary_certificate, PortalApi.V1.PostPrimaryCertificateView, "post_primary_certificate.json")
  end

  def render("post_primary_certificate.json", %{post_primary_certificate: post_primary_certificate}) do
    %{id: post_primary_certificate.id,
      user_id: post_primary_certificate.user_id,
      examination_type_id: post_primary_certificate.examination_type_id,
      year_obtained: post_primary_certificate.year_obtained,
      registration_no: post_primary_certificate.registration_no}
  end
end
