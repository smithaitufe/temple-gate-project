defmodule PortalApi.V1.ProgramView do
  use PortalApi.Web, :view

  def render("index.json", %{programs: programs}) do
    %{data: render_many(programs, PortalApi.V1.ProgramView, "program.json")}
  end

  def render("show.json", %{program: program}) do
    %{data: render_one(program, PortalApi.V1.ProgramView, "program.json")}
  end

  def render("program.json", %{program: program}) do
    %{id: program.id,
      name: program.name,
      description: program.description,
      text: program.text,
      duration: program.duration}

    |> render_levels(%{levels: program.levels})
  end


  def render_levels(json, %{levels: levels}) when is_list(levels) do
    Map.put(json, :levels, render_many(levels, PortalApi.V1.LevelView, "level.json"))
  end
  def render_levels(json, _) do
    json
  end


end
