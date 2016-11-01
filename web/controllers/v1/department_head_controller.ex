defmodule PortalApi.V1.DepartmentHeadController do
  use PortalApi.Web, :controller

  alias PortalApi.DepartmentHead

  plug :scrub_params, "department_head" when action in [:create, :update]

  def index(conn, params) do
    department_heads = DepartmentHead
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(DepartmentHead.associations)

    render(conn, "index.json", department_heads: department_heads)
  end

  def create(conn, %{"department_head" => department_head_params}) do
    changeset = DepartmentHead.changeset(%DepartmentHead{}, department_head_params)

    case Repo.insert(changeset) do
      {:ok, department_head} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_department_head_path(conn, :show, department_head))
        |> render("show.json", department_head: department_head)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    department_head = Repo.get!(DepartmentHead, id)
    render(conn, "show.json", department_head: department_head)
  end

  def update(conn, %{"id" => id, "department_head" => department_head_params}) do
    department_head = Repo.get!(DepartmentHead, id)
    changeset = DepartmentHead.changeset(department_head, department_head_params)

    case Repo.update(changeset) do
      {:ok, department_head} ->
        render(conn, "show.json", department_head: department_head)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    department_head = Repo.get!(DepartmentHead, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(department_head)

    send_resp(conn, :no_content, "")
  end


  defp build_query(query, []), do: query
  defp build_query(query, [{"user_id", user_id} | tail ]) do
    query
    |> Ecto.Query.where([d], d.user_id == ^user_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"department_id", department_id} | tail ]) do
    query
    |> Ecto.Query.where([d], d.department_id == ^department_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"active", active} | tail ]) do
    query
    |> Ecto.Query.where([d], d.active == ^active)
    |> build_query(tail)
  end
end
