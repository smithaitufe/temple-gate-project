defmodule PortalApi.V1.StudentAssignmentController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentAssignment

  plug :scrub_params, "student_assignment" when action in [:create, :update]

  def index(conn, _params) do
    student_assignments = Repo.all(StudentAssignment)
    render(conn, "index.json", student_assignments: student_assignments)
  end

  def create(conn, %{"student_assignment" => student_assignment_params}) do
    changeset = StudentAssignment.changeset(%StudentAssignment{}, student_assignment_params)

    case Repo.insert(changeset) do
      {:ok, student_assignment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_assignment_path(conn, :show, student_assignment))
        |> render("show.json", student_assignment: student_assignment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_assignment = Repo.get!(StudentAssignment, id)
    render(conn, "show.json", student_assignment: student_assignment)
  end

  def update(conn, %{"id" => id, "student_assignment" => student_assignment_params}) do
    student_assignment = Repo.get!(StudentAssignment, id)
    changeset = StudentAssignment.changeset(student_assignment, student_assignment_params)

    case Repo.update(changeset) do
      {:ok, student_assignment} ->
        render(conn, "show.json", student_assignment: student_assignment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_assignment = Repo.get!(StudentAssignment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_assignment)

    send_resp(conn, :no_content, "")
  end
end
