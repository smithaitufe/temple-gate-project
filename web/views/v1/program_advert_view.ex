defmodule PortalApi.V1.ProgramAdvertView do
  use PortalApi.Web, :view

  def render("index.json", %{program_adverts: program_adverts}) do
    %{data: render_many(program_adverts, PortalApi.V1.ProgramAdvertView, "program_advert.json")}
  end

  def render("show.json", %{program_advert: program_advert}) do
    %{data: render_one(program_advert, PortalApi.V1.ProgramAdvertView, "program_advert.json")}
  end

  def render("program_advert.json", %{program_advert: program_advert}) do
    %{id: program_advert.id,
      program_id: program_advert.program_id,
      academic_session_id: program_advert.academic_session_id,
      opening_date: program_advert.opening_date,
      closing_date: program_advert.closing_date,
      active: program_advert.active}
    |> PortalApi.V1.AcademicSessionView.render_academic_session(%{academic_session: program_advert.academic_session})
    |> PortalApi.V1.ProgramView.render_program(%{program: program_advert.program})
  end
end
