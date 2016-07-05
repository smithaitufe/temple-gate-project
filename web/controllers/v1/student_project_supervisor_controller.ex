defmodule PortalApi.V1.StudentProjectSupervisorController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentProjectSupervisor

  plug :scrub_params, "student_project_supervisor" when action in [:create, :update]

  def index(conn, _params) do
    student_project_supervisors = Repo.all(StudentProjectSupervisor)
    render(conn, "index.json", student_project_supervisors: student_project_supervisors)
  end

  def create(conn, %{"student_project_supervisor" => student_project_supervisor_params}) do
    changeset = StudentProjectSupervisor.changeset(%StudentProjectSupervisor{}, student_project_supervisor_params)

    case Repo.insert(changeset) do
      {:ok, student_project_supervisor} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_project_supervisor_path(conn, :show, student_project_supervisor))
        |> render("show.json", student_project_supervisor: student_project_supervisor)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_project_supervisor = Repo.get!(StudentProjectSupervisor, id)
    render(conn, "show.json", student_project_supervisor: student_project_supervisor)
  end

  def update(conn, %{"id" => id, "student_project_supervisor" => student_project_supervisor_params}) do
    student_project_supervisor = Repo.get!(StudentProjectSupervisor, id)
    changeset = StudentProjectSupervisor.changeset(student_project_supervisor, student_project_supervisor_params)

    case Repo.update(changeset) do
      {:ok, student_project_supervisor} ->
        render(conn, "show.json", student_project_supervisor: student_project_supervisor)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_project_supervisor = Repo.get!(StudentProjectSupervisor, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_project_supervisor)

    send_resp(conn, :no_content, "")
  end
end
