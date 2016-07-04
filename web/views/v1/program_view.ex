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
  end
end
