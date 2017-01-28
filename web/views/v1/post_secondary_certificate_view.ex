defmodule PortalApi.V1.PostSecondaryCertificateView do
  use PortalApi.Web, :view

  def render("index.json", %{post_secondary_certificates: post_secondary_certificates}) do
    render_many(post_secondary_certificates, PortalApi.V1.PostSecondaryCertificateView, "post_secondary_certificate.json")
  end

  def render("show.json", %{post_secondary_certificate: post_secondary_certificate}) do
    render_one(post_secondary_certificate, PortalApi.V1.PostSecondaryCertificateView, "post_secondary_certificate.json")
  end

  def render("post_secondary_certificate.json", %{post_secondary_certificate: post_secondary_certificate}) do
    %{id: post_secondary_certificate.id,
      user_id: post_secondary_certificate.user_id,
      institution: post_secondary_certificate.institution,
      course_studied: post_secondary_certificate.course_studied,
      cgpa: post_secondary_certificate.cgpa,
      year_admitted: post_secondary_certificate.year_admitted,
      year_graduated: post_secondary_certificate.year_graduated,
      verified: post_secondary_certificate.verified,
      verified_by_user_id: post_secondary_certificate.verified_by_user_id,
      verified_at: post_secondary_certificate.verified_at}
  end
end
