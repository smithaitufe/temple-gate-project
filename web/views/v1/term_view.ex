defmodule PortalApi.V1.TermView do
  use PortalApi.Web, :view

  def render("index.json", %{terms: terms}) do
    %{data: render_many(terms, PortalApi.V1.TermView, "term.json")}
  end

  def render("show.json", %{term: term}) do
    %{data: render_one(term, PortalApi.V1.TermView, "term.json")}
  end

  def render("term.json", %{term: term}) do
    %{id: term.id,
      description: term.description,
      term_set_id: term.term_set_id}
  end
end
