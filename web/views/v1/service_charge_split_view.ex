defmodule PortalApi.V1.ServiceChargeSplitView do
  use PortalApi.Web, :view

  def render("index.json", %{service_charge_splits: service_charge_splits}) do
    %{data: render_many(service_charge_splits, PortalApi.V1.ServiceChargeSplitView, "service_charge_split.json")}
  end

  def render("show.json", %{service_charge_split: service_charge_split}) do
    %{data: render_one(service_charge_split, PortalApi.V1.ServiceChargeSplitView, "service_charge_split.json")}
  end

  def render("service_charge_split.json", %{service_charge_split: service_charge_split}) do
    %{id: service_charge_split.id,
      amount: service_charge_split.amount,
      name: service_charge_split.name,
      bank_code: service_charge_split.bank_code,
      account: service_charge_split.account,
      is_required: service_charge_split.is_required,
      service_charge_id: service_charge_split.service_charge_id}
  end
end
