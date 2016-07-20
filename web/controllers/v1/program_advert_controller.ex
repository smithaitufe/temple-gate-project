defmodule PortalApi.V1.ProgramAdvertController do
  use PortalApi.Web, :controller

  alias PortalApi.ProgramAdvert

  plug :scrub_params, "program_advert" when action in [:create, :update]

  def index(conn, params) do
    program_adverts = ProgramAdvert
    |> build_program_advert_query(Map.to_list(params))
    |> Repo.all
    |> preload_models

    render(conn, "index.json", program_adverts: program_adverts)
  end

  def create(conn, %{"program_advert" => program_advert_params}) do
    changeset = ProgramAdvert.changeset(%ProgramAdvert{}, program_advert_params)

    case Repo.insert(changeset) do
      {:ok, program_advert} ->
        program_advert = preload_models(program_advert)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_program_advert_path(conn, :show, program_advert))
        |> render("show.json", program_advert: program_advert)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    program_advert = ProgramAdvert
    |> Repo.get!(id)
    |> preload_models

    render(conn, "show.json", program_advert: program_advert)
  end

  def update(conn, %{"id" => id, "program_advert" => program_advert_params}) do
    program_advert = Repo.get!(ProgramAdvert, id)
    changeset = ProgramAdvert.changeset(program_advert, program_advert_params)

    case Repo.update(changeset) do
      {:ok, program_advert} ->
        program_advert = preload_models(program_advert)
        render(conn, "show.json", program_advert: program_advert)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    program_advert = Repo.get!(ProgramAdvert, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(program_advert)

    send_resp(conn, :no_content, "")
  end

  defp build_program_advert_query(query, [{"program_id", program_id} | tail]) do
    query
    |> Ecto.Query.where([pa], pa.program_id == ^program_id)
    |> build_program_advert_query(tail)
  end
  defp build_program_advert_query(query, [{"academic_session_id", academic_session_id} | tail]) do
    query
    |> Ecto.Query.where([pa], pa.academic_session_id == ^academic_session_id)
    |> build_program_advert_query(tail)
  end
  defp build_program_advert_query(query, []), do: query

  defp preload_models(query) do
    query
    |> Repo.preload([:program, :academic_session])
  end
end
