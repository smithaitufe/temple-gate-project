defmodule PortalApi.V1.ProgramDepartmentController do
  use PortalApi.Web, :controller

  alias PortalApi.ProgramDepartment

  plug :scrub_params, "program_department" when action in [:create, :update]

  def index(conn, _params) do
    program_departments = Repo.all(ProgramDepartment)
    render(conn, "index.json", program_departments: program_departments)
  end

  def create(conn, %{"program_department" => program_department_params}) do
    changeset = ProgramDepartment.changeset(%ProgramDepartment{}, program_department_params)

    case Repo.insert(changeset) do
      {:ok, program_department} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_program_department_path(conn, :show, program_department))
        |> render("show.json", program_department: program_department)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    program_department = Repo.get!(ProgramDepartment, id)
    render(conn, "show.json", program_department: program_department)
  end

  def update(conn, %{"id" => id, "program_department" => program_department_params}) do
    program_department = Repo.get!(ProgramDepartment, id)
    changeset = ProgramDepartment.changeset(program_department, program_department_params)

    case Repo.update(changeset) do
      {:ok, program_department} ->
        render(conn, "show.json", program_department: program_department)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    program_department = Repo.get!(ProgramDepartment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(program_department)

    send_resp(conn, :no_content, "")
  end
end
