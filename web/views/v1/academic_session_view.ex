defmodule PortalApi.V1.AcademicSessionView do
  use PortalApi.Web, :view
  alias PortalApi.V1.AcademicSessionView

  def render("index.json", %{academic_sessions: academic_sessions}) do
    render_many(academic_sessions, AcademicSessionView, "academic_session.json")
  end

  def render("show.json", %{academic_session: academic_session}) do
    render_one(academic_session, AcademicSessionView, "academic_session.json")
  end

  def render("academic_session.json", %{academic_session: academic_session}) do
    %{
      id: academic_session.id,
      opening_date: academic_session.opening_date,
      closing_date: academic_session.closing_date,
      description: academic_session.description,
      active: academic_session.active
    }
  end




end
