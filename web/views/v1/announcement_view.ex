defmodule PortalApi.V1.AnnouncementView do
  use PortalApi.Web, :view

  def render("index.json", %{announcements: announcements}) do
    render_many(announcements, PortalApi.V1.AnnouncementView, "announcement.json")
  end

  def render("show.json", %{announcement: announcement}) do
    render_one(announcement, PortalApi.V1.AnnouncementView, "announcement.json")
  end

  def render("announcement.json", %{announcement: announcement}) do
    %{id: announcement.id,
      heading: announcement.heading,
      lead: announcement.lead,
      body: announcement.body,      
      expires_at: announcement.expires_at,
      active: announcement.active,
      show_as_dialog: announcement.show_as_dialog,
      }
  end
end
