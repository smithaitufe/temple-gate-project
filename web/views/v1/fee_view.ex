defmodule PortalApi.V1.FeeView do
  use PortalApi.Web, :view

  def render("index.json", %{fees: fees}) do
    %{data: render_many(fees, PortalApi.V1.FeeView, "fee.json")}
  end

  def render("show.json", %{fee: fee}) do
    %{data: render_one(fee, PortalApi.V1.FeeView, "fee.json")}
  end

  def render("fee.json", %{fee: fee}) do
    %{id: fee.id,
      code: fee.code,
      description: fee.description,
      amount: fee.amount,
      is_catchment_area: fee.is_catchment_area,
      program_id: fee.program_id,
      level_id: fee.level_id,
      service_charge_type_id: fee.service_charge_type_id,
      category_id: fee.category_id}
  end
end
