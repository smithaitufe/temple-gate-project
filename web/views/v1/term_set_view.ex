defmodule PortalApi.V1.TermSetView do
  use PortalApi.Web, :view

  def render("index.json", %{term_sets: term_sets}) do
    render_many(term_sets, PortalApi.V1.TermSetView, "term_set.json")
  end

  def render("show.json", %{term_set: term_set}) do
    render_one(term_set, PortalApi.V1.TermSetView, "term_set.json")
  end

  def render("term_set.json", %{term_set: term_set}) do
    %{id: term_set.id,
      name: term_set.name,
      display_name: term_set.display_name}
  end
end
