defmodule PortalApi.V1.FacultyController do
  use PortalApi.Web, :controller

  alias PortalApi.Faculty

  plug :scrub_params, "faculty" when action in [:create, :update]

  def index(conn, _params) do
    faculties = Repo.all(Faculty)
    render(conn, "index.json", faculties: faculties)
  end

  def create(conn, %{"faculty" => faculty_params}) do
    changeset = Faculty.changeset(%Faculty{}, faculty_params)

    case Repo.insert(changeset) do
      {:ok, faculty} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_faculty_path(conn, :show, faculty))
        |> render("show.json", faculty: faculty)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    faculty = Repo.get!(Faculty, id)
    render(conn, "show.json", faculty: faculty)
  end

  def update(conn, %{"id" => id, "faculty" => faculty_params}) do
    faculty = Repo.get!(Faculty, id)
    changeset = Faculty.changeset(faculty, faculty_params)

    case Repo.update(changeset) do
      {:ok, faculty} ->
        render(conn, "show.json", faculty: faculty)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    faculty = Repo.get!(Faculty, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(faculty)

    send_resp(conn, :no_content, "")
  end
end
