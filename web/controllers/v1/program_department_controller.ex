defmodule PortalApi.V1.ProgramDepartmentController do
  use PortalApi.Web, :controller

  alias PortalApi.ProgramDepartment

  plug :scrub_params, "program_department" when action in [:create, :update]

  def index(conn, params) do
    program_departments = ProgramDepartment
    |> build_program_department_query(Map.to_list(params))
    |> Repo.all
    |> preload_models

    render(conn, "index.json", program_departments: program_departments)
  end

  def create(conn, %{"program_department" => program_department_params}) do
    changeset = ProgramDepartment.changeset(%ProgramDepartment{}, program_department_params)

    case Repo.insert(changeset) do
      {:ok, program_department} ->
        program_department = preload_models(program_department)
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
    |> preload_models

    render(conn, "show.json", program_department: program_department)
  end

  def update(conn, %{"id" => id, "program_department" => program_department_params}) do

    program_department = Repo.get!(ProgramDepartment, id)
    changeset = ProgramDepartment.changeset(program_department, program_department_params)

    case Repo.update(changeset) do
      {:ok, program_department} ->
        program_department = preload_models(program_department)
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

  defp build_program_department_query(query, [{"program_id", program_id} | tail]) do
    query
    # |> Ecto.Query.join(:left, [pd], d in assoc(pd, :department))
    # |> Ecto.Query.join(:left, [pd, _], p in assoc(pd, :program))
    # |> Ecto.Query.where([_, _, p], p.id == ^program_id)
    |> Ecto.Query.where([pd], pd.program_id == ^program_id)
    |> build_program_department_query(tail)
  end
  defp build_program_department_query(query, [{"admit", admit} | tail]) do
    query
    # |> Ecto.Query.join(:left, [pd], d in assoc(pd, :department))
    # |> Ecto.Query.join(:left, [pd, _], p in assoc(pd, :program))
    # |> Ecto.Query.where([_, _, p], p.id == ^program_id)
    |> Ecto.Query.where([pd], pd.admit == ^admit)
    |> build_program_department_query(tail)
  end
  defp build_program_department_query(query, []), do: query
  defp preload_models(query) do
    # from q in query,
    # preload: [{:department, [:faculty, :department_type]}, :program]

    Repo.preload(query, [{:department, [:faculty, :department_type]}, :program])
  end


end
