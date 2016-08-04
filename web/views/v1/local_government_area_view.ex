defmodule PortalApi.V1.LocalGovernmentAreaView do
  use PortalApi.Web, :view

  def render("index.json", %{local_government_areas: local_government_areas}) do
    render_many(local_government_areas, PortalApi.V1.LocalGovernmentAreaView, "local_government_area.json")
  end

  def render("show.json", %{local_government_area: local_government_area}) do
    render_one(local_government_area, PortalApi.V1.LocalGovernmentAreaView, "local_government_area.json")
  end

  def render("local_government_area.json", %{local_government_area: local_government_area}) do
    %{
      id: local_government_area.id,
      name: local_government_area.name,
      state_id: local_government_area.state_id
    }
  end
end
