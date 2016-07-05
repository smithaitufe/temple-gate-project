defmodule PortalApi.V1.PaymentItemView do
  use PortalApi.Web, :view

  def render("index.json", %{payment_items: payment_items}) do
    %{data: render_many(payment_items, PortalApi.V1.PaymentItemView, "payment_item.json")}
  end

  def render("show.json", %{payment_item: payment_item}) do
    %{data: render_one(payment_item, PortalApi.V1.PaymentItemView, "payment_item.json")}
  end

  def render("payment_item.json", %{payment_item: payment_item}) do
    %{id: payment_item.id,
      payment_id: payment_item.payment_id,
      fee_id: payment_item.fee_id,
      amount: payment_item.amount}
  end
end
