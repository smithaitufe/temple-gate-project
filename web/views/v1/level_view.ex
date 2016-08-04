defmodule PortalApi.V1.LevelView do
  use PortalApi.Web, :view
  alias PortalApi.V1.LevelView

  def render("index.json", %{levels: levels}) do
    render_many(levels, LevelView, "level.json")
  end

  def render("show.json", %{level: level}) do
    render_one(level, LevelView, "level.json")
  end

  def render("level.json", %{level: level}) do
    %{id: level.id,
      description: level.description,
      program_id: level.program_id}
  end

  def render_level(json, %{level: level}) when is_map(level) do
    Map.put(json, :level, render_one(level, LevelView, "level.json"))
  end
  def render_level(json, _) do
    json
  end


end
