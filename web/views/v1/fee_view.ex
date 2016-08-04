defmodule PortalApi.V1.FeeView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{FeeView, ProgramView, LevelView}

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
      is_catchment_area: fee.is_catchment_area,
      program_id: fee.program_id,
      level_id: fee.level_id,
      fee_category_id: fee.fee_category_id
    }
    # |> ProgramView.render_program(%{program: fee.program})
    # |> LevelView.render_level(%{level: fee.level})
    |> Map.put(:program, ProgramView.render("show.json", program: fee.program))
    |> Map.put(:level, LevelView.render("show.json", level: fee.level))
  end
  #
  # defp render_level(json, %{level: level}) when is_map(level) do
  #   Map.put(json, :level, render_one(level, PortalApi.V1.LevelView, "level.json"))
  # end
  # defp render_level(json, _) do
  #   json
  # end
  #
  # defp render_program(json, %{program: program}) when is_map(program) do
  #   Map.put(json, :program, render_one(program, PortalApi.V1.ProgramView, "program.json"))
  # end
  # defp render_program(json, _) do
  #   json
  # end



end
