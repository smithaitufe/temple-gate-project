defmodule PortalApi.V1.ProgramView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{ProgramView, LevelView}

  def render("index.json", %{programs: programs}) do
    render_many(programs, ProgramView, "program.json")
  end

  def render("show.json", %{program: program}) do
    render_one(program, ProgramView, "program.json")
  end

  def render("program.json", %{program: program}) do
    %{
      id: program.id,
      name: program.name,
      description: program.description,
      text: program.text,
      duration: program.duration
    }
    |> Map.put(:levels, render_many(program.levels, LevelView, "level.json"))
  end

  def render_program(json, %{program: program}) when is_map(program) do
    Map.put(json, :program, render_one(program, ProgramView, "program.json"))
  end
  def render_program(json, _) do
    json
  end

end
