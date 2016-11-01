defmodule PortalApi.V1.ProductView do
  use PortalApi.Web, :view

  def render("index.json", %{products: products}) do
    %{data: render_many(products, PortalApi.V1.ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, PortalApi.V1.ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      sold_by_user_id: product.sold_by_user_id,
      name: product.name,
      description: product.description,
      long_description: product.long_description,
      price: product.price,
      quantity: product.quantity,
      available_at: product.available_at,
      unavailable_at: product.unavailable_at,
      is_negotiable: product.is_negotiable,
      is_sold: product.is_sold}
  end
end
