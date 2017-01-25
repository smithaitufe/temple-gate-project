defmodule PortalApi.V1.PostPrimaryCertificateItemView do
  use PortalApi.Web, :view

  def render("index.json", %{post_primary_certificate_items: post_primary_certificate_items}) do
    render_many(post_primary_certificate_items, PortalApi.V1.PostPrimaryCertificateItemView, "post_primary_certificate_item.json")
  end

  def render("show.json", %{post_primary_certificate_item: post_primary_certificate_item}) do
    render_one(post_primary_certificate_item, PortalApi.V1.PostPrimaryCertificateItemView, "post_primary_certificate_item.json")
  end

  def render("post_primary_certificate_item.json", %{post_primary_certificate_item: post_primary_certificate_item}) do
    %{id: post_primary_certificate_item.id,
      post_primary_certificate_id: post_primary_certificate_item.post_primary_certificate_id,
      subject_id: post_primary_certificate_item.subject_id,
      grade_id: post_primary_certificate_item.grade_id}
  end
end
