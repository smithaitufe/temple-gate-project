defmodule PortalApi.V1.TermView do
  use PortalApi.Web, :view
  alias PortalApi.V1.TermView

  def render("index.json", %{terms: terms}) do
    %{data: render_many(terms, TermView, "term.json")}
  end
  def render("show.json", %{term: term}) do
    %{data: render_one(term, TermView, "term.json")}
  end
  def render("term.json", %{term: term}) do
    %{id: term.id,
      description: term.description,
      term_set_id: term.term_set_id}
  end

  def render_term(json, key, %{term: term}) when is_map(term) do
    Map.put(json, key, render_one(term, TermView, "term.json"))
  end
  def render_term(json, key, _) do
    json
  end
end
