defmodule PortalApi.V1.AcademicSessionController do
  use PortalApi.Web, :controller

  alias PortalApi.AcademicSession

  plug :scrub_params, "academic_session" when action in [:create, :update]

  def index(conn, _params) do
    academic_sessions = Repo.all(AcademicSession)
    render(conn, "index.json", academic_sessions: academic_sessions)
  end

  def create(conn, %{"academic_session" => academic_session_params}) do
    changeset = AcademicSession.changeset(%AcademicSession{}, academic_session_params)

    case Repo.insert(changeset) do
      {:ok, academic_session} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_academic_session_path(conn, :show, academic_session))
        |> render("show.json", academic_session: academic_session)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    academic_session = Repo.get!(AcademicSession, id)
    render(conn, "show.json", academic_session: academic_session)
  end

  def update(conn, %{"id" => id, "academic_session" => academic_session_params}) do
    academic_session = Repo.get!(AcademicSession, id)
    changeset = AcademicSession.changeset(academic_session, academic_session_params)

    case Repo.update(changeset) do
      {:ok, academic_session} ->
        render(conn, "show.json", academic_session: academic_session)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    academic_session = Repo.get!(AcademicSession, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(academic_session)

    send_resp(conn, :no_content, "")
  end
end
