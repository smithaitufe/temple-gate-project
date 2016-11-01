defmodule PortalApi.V1.OrderView do
  use PortalApi.Web, :view

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, PortalApi.V1.OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, PortalApi.V1.OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{id: order.id,
      ordered_by_user_id: order.ordered_by_user_id,
      product_id: order.product_id,
      selling_amount: order.selling_amount,
      buying_amount: order.buying_amount,
      is_invited: order.is_invited,
      buyer: order.buyer}
  end
end
