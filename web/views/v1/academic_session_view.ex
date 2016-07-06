defmodule PortalApi.V1.AcademicSessionView do
  use PortalApi.Web, :view

  def render("index.json", %{academic_sessions: academic_sessions}) do
    %{data: render_many(academic_sessions, PortalApi.V1.AcademicSessionView, "academic_session.json")}
  end

  def render("show.json", %{academic_session: academic_session}) do
    %{data: render_one(academic_session, PortalApi.V1.AcademicSessionView, "academic_session.json")}
  end

  def render("academic_session.json", %{academic_session: academic_session}) do
    %{id: academic_session.id,
      opening_date: academic_session.opening_date,
      closing_date: academic_session.closing_date,
      description: academic_session.description,
      is_current: academic_session.is_current}
  end
end
