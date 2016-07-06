defmodule PortalApi.V1.ProgramController do
  use PortalApi.Web, :controller

  alias PortalApi.Program

  plug :scrub_params, "program" when action in [:create, :update]

  def index(conn, _params) do
    programs = Program
    |> Program.load_levels
    |> Repo.all

    
    render(conn, "index.json", programs: programs)
  end

  def create(conn, %{"program" => program_params}) do
    changeset = Program.changeset(%Program{}, program_params)

    case Repo.insert(changeset) do
      {:ok, program} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_program_path(conn, :show, program))
        |> render("show.json", program: program)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    program = Repo.get!(Program, id)
    render(conn, "show.json", program: program)
  end

  def update(conn, %{"id" => id, "program" => program_params}) do
    program = Repo.get!(Program, id)
    changeset = Program.changeset(program, program_params)

    case Repo.update(changeset) do
      {:ok, program} ->
        render(conn, "show.json", program: program)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    program = Repo.get!(Program, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(program)

    send_resp(conn, :no_content, "")
  end
end
