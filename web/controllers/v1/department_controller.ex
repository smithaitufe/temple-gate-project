defmodule PortalApi.V1.DepartmentController do
  use PortalApi.Web, :controller

  alias PortalApi.Department

  plug :scrub_params, "department" when action in [:create, :update]

  def index(conn, params) do
    departments = Department
    |> build_department_query(Map.to_list(params))
    |> Repo.all
    |> preload_models
    render(conn, "index.json", departments: departments)
  end

  def create(conn, %{"department" => department_params}) do
    changeset = Department.changeset(%Department{}, department_params)

    case Repo.insert(changeset) do
      {:ok, department} ->
        department = preload_models(department)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_department_path(conn, :show, department))
        |> render("show.json", department: department)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    department = Repo.get!(Department, id)
    |> preload_models

    render(conn, "show.json", department: department)
  end

  def update(conn, %{"id" => id, "department" => department_params}) do
    department = Repo.get!(Department, id)
    changeset = Department.changeset(department, department_params)

    case Repo.update(changeset) do
      {:ok, department} ->
        render(conn, "show.json", department: preload_models(department))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    department = Repo.get!(Department, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(department)

    send_resp(conn, :no_content, "")
  end

  defp build_department_query(query, []), do: query
  defp build_department_query(query, [{"faculty_id", faculty_id} | tail]) do
    query
    |> Ecto.Query.where([d], d.faculty_id == ^faculty_id)
    |> build_department_query(tail)
  end
  defp build_department_query(query, [{"department_type_id", department_type_id} | tail]) do
    query
    |> Ecto.Query.where([d], d.department_type_id == ^department_type_id)
    |> build_department_query(tail)
  end
  defp build_department_query(query, [{"order_by", field} | tail]) do
    query
    |> Ecto.Query.order_by([asc: ^String.to_existing_atom(field)])
    |> build_department_query(tail)
  end
  defp build_department_query(query, [{"program_id", program_id} | tail]) do
    query
    |> Ecto.Query.join(:left, [d], pd in assoc(d, :program_departments))
    |> Ecto.Query.join(:left, [d, pd], p in assoc(pd, :program))
    |> Ecto.Query.where([d, pd, p], p.id == ^program_id)
    |> build_department_query(tail)
  end

  # defp build_department_query(query, [{"available_department", value} | tail]) do
  #   query
  #   |> Ecto.Query.join(:inner, [d], pd in assoc(d, :program_departments))
  #   |> Ecto.Query.join(:inner, [d, pd], p in assoc(pd, :program))
  #   |> Ecto.Query.where([d, pd, p], p.id == ^program_id)
  #   |> build_department_query(tail)
  # end

  defp preload_models(query) do
    Repo.preload(query, [:faculty, :department_type])
  end

end
