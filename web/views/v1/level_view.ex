defmodule PortalApi.V1.LevelView do
  use PortalApi.Web, :view

  def render("index.json", %{levels: levels}) do
    %{data: render_many(levels, PortalApi.V1.LevelView, "level.json")}
  end

  def render("show.json", %{level: level}) do
    %{data: render_one(level, PortalApi.V1.LevelView, "level.json")}
  end

  def render("level.json", %{level: level}) do
    %{id: level.id,
      description: level.description,
      program_id: level.program_id}
  end
end
