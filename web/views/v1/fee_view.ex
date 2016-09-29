defmodule PortalApi.V1.FeeView do
  use     PortalApi.Web, :view
  alias   PortalApi.V1.{FeeView, ProgramView, LevelView, TermView}

  def render("index.json", %{fees: fees}) do
    render_many(fees, FeeView, "fee.json")
  end

  def render("show.json", %{fee: fee}) do
    render_one(fee, FeeView, "fee.json")
  end

  def render("fee.json", %{fee: fee}) do
    %{
      id: fee.id,
      code: fee.code,
      description: fee.description,
      amount: fee.amount,
      service_charge: fee.service_charge,
      program_id: fee.program_id,
      level_id: fee.level_id,
      fee_category_id: fee.fee_category_id,
      payer_category_id: fee.payer_category_id,
      area_type_id: fee.area_type_id
    }
    |> Map.put(:program, render_one(fee.program, ProgramView, "program.json"))
    |> Map.put(:level, render_one(fee.level, LevelView, "level.json"))
    |> Map.put(:fee_category, render_one(fee.fee_category, TermView, "term.json"))
    |> Map.put(:payer_category, render_one(fee.payer_category, TermView, "term.json"))
    |> Map.put(:area_type, render_one(fee.area_type, TermView, "term.json"))
  end

end
