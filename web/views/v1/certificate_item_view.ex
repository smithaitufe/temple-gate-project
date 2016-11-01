defmodule PortalApi.V1.CertificateItemView do
  use PortalApi.Web, :view

  def render("index.json", %{certificate_items: certificate_items}) do
    render_many(certificate_items, PortalApi.V1.CertificateItemView, "certificate_item.json")
  end

  def render("show.json", %{certificate_item: certificate_item}) do
    render_one(certificate_item, PortalApi.V1.CertificateItemView, "certificate_item.json")
  end

  def render("certificate_item.json", %{certificate_item: certificate_item}) do
    %{id: certificate_item.id,
      certificate_id: certificate_item.certificate_id,
      subject_id: certificate_item.subject_id,
      grade_id: certificate_item.grade_id}
  end
end
