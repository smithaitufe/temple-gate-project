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
      program_id: fee.program_id,
      level_id: fee.level_id,
      fee_category_id: fee.fee_category_id,
      payer_category_id: fee.payer_category_id,
      is_catchment: fee.is_catchment,
      is_all: fee.is_all,
    }
    |> Map.put(:program, render_one(fee.program, ProgramView, "program.json"))
    |> Map.put(:level, render_one(fee.level, LevelView, "level.json"))
    |> Map.put(:fee_category, render_one(fee.fee_category, TermView, "term.json"))
    |> Map.put(:payer_category, render_one(fee.payer_category, TermView, "term.json"))
    
  end

end
