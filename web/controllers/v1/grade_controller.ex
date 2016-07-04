defmodule PortalApi.V1.GradeController do
  use PortalApi.Web, :controller

  alias PortalApi.Grade

  plug :scrub_params, "grade" when action in [:create, :update]

  def index(conn, _params) do
    grades = Repo.all(Grade)
    render(conn, "index.json", grades: grades)
  end

  def create(conn, %{"grade" => grade_params}) do
    changeset = Grade.changeset(%Grade{}, grade_params)

    case Repo.insert(changeset) do
      {:ok, grade} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_grade_path(conn, :show, grade))
        |> render("show.json", grade: grade)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    grade = Repo.get!(Grade, id)
    render(conn, "show.json", grade: grade)
  end

  def update(conn, %{"id" => id, "grade" => grade_params}) do
    grade = Repo.get!(Grade, id)
    changeset = Grade.changeset(grade, grade_params)

    case Repo.update(changeset) do
      {:ok, grade} ->
        render(conn, "show.json", grade: grade)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    grade = Repo.get!(Grade, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(grade)

    send_resp(conn, :no_content, "")
  end
end
