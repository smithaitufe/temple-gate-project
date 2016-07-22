defmodule PortalApi.V1.NewsroomView do
  use PortalApi.Web, :view

  def render("index.json", %{newsrooms: newsrooms}) do
    %{data: render_many(newsrooms, PortalApi.V1.NewsroomView, "newsroom.json")}
  end

  def render("show.json", %{newsroom: newsroom}) do
    %{data: render_one(newsroom, PortalApi.V1.NewsroomView, "newsroom.json")}
  end

  def render("newsroom.json", %{newsroom: newsroom}) do
    %{id: newsroom.id,
      lead: newsroom.lead,
      body: newsroom.body,
      release_at: newsroom.release_at,
      active: newsroom.active,
      duration: newsroom.duration}
  end
end
