defmodule PortalApi.V1.ProgramAdvertView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{ProgramAdvertView, AcademicSessionView, ProgramView}

  def render("index.json", %{program_adverts: program_adverts}) do
    render_many(program_adverts, ProgramAdvertView, "program_advert.json")
  end

  def render("show.json", %{program_advert: program_advert}) do
    render_one(program_advert, ProgramAdvertView, "program_advert.json")
  end

  def render("program_advert.json", %{program_advert: program_advert}) do
    %{
      id: program_advert.id,
      program_id: program_advert.program_id,
      academic_session_id: program_advert.academic_session_id,
      opening_date: program_advert.opening_date,
      closing_date: program_advert.closing_date,
      active: program_advert.active
    }
    |> Map.put(:academic_session, AcademicSessionView.render("academic_session.json", %{academic_session: program_advert.academic_session}))
    |> ProgramView.render_program(%{program: program_advert.program})
  end
end
