defmodule PortalApi.V1.ServiceChargeView do
  use PortalApi.Web, :view

  def render("index.json", %{service_charges: service_charges}) do
    render_many(service_charges, PortalApi.V1.ServiceChargeView, "service_charge.json")
  end

  def render("show.json", %{service_charge: service_charge}) do
    render_one(service_charge, PortalApi.V1.ServiceChargeView, "service_charge.json")
  end

  def render("service_charge.json", %{service_charge: service_charge}) do
    %{id: service_charge.id,
      amount: service_charge.amount,
      active: service_charge.active,
      program_id: service_charge.program_id,
      payer_category_id: service_charge.payer_category_id}
      |> Map.put(:service_charge_splits, render_many(service_charge.service_charge_splits, PortalApi.V1.ServiceChargeSplitView, "service_charge_split.json"))
  end
end
