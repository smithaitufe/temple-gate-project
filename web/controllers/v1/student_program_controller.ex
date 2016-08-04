defmodule PortalApi.V1.StudentProgramController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentProgram

  plug :scrub_params, "student_program" when action in [:create, :update]

  def index(conn, _params) do
    student_programs = Repo.all(StudentProgram)
    render(conn, "index.json", student_programs: student_programs)
  end

  def create(conn, %{"student_program" => student_program_params}) do
    changeset = StudentProgram.changeset(%StudentProgram{}, student_program_params)

    case Repo.insert(changeset) do
      {:ok, student_program} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_program_path(conn, :show, student_program))
        |> render("show.json", student_program: student_program)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_program = Repo.get!(StudentProgram, id)
    render(conn, "show.json", student_program: student_program)
  end

  def update(conn, %{"id" => id, "student_program" => student_program_params}) do
    student_program = Repo.get!(StudentProgram, id)
    changeset = StudentProgram.changeset(student_program, student_program_params)

    case Repo.update(changeset) do
      {:ok, student_program} ->
        render(conn, "show.json", student_program: student_program)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_program = Repo.get!(StudentProgram, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_program)

    send_resp(conn, :no_content, "")
  end
end
