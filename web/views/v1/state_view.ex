defmodule PortalApi.V1.StateView do
  use PortalApi.Web, :view

  def render("index.json", %{states: states}) do
    %{data: render_many(states, PortalApi.V1.StateView, "state.json")}
  end

  def render("show.json", %{state: state}) do
    %{data: render_one(state, PortalApi.V1.StateView, "state.json")}
  end

  def render("state.json", %{state: state}) do
    %{id: state.id,
      name: state.name,
      country_id: state.country_id}
  end
end
