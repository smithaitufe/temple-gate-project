defmodule PortalApi.V1.RoleController do
  use PortalApi.Web, :controller

  alias PortalApi.Role

  plug :scrub_params, "role" when action in [:create, :update]

  def index(conn, params) do
    roles = Role
    |> build_query(Map.to_list(params))
    |> Repo.all

    render(conn, "index.json", roles: roles)
  end

  def create(conn, %{"role" => role_params}) do
    changeset = Role.changeset(%Role{}, role_params)

    case Repo.insert(changeset) do
      {:ok, role} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_role_path(conn, :show, role))
        |> render("show.json", role: role)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Repo.get!(Role, id)
    render(conn, "show.json", role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Repo.get!(Role, id)
    changeset = Role.changeset(role, role_params)

    case Repo.update(changeset) do
      {:ok, role} ->
        render(conn, "show.json", role: role)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Repo.get!(Role, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(role)

    send_resp(conn, :no_content, "")
  end

  defp build_query(query, [{ "name", name} | tail]) do
    query 
    |> Ecto.Query.where([role], fragment("lower(?) = ?", role.name, ^String.downcase(name)))
    |> build_query(tail)
  end
  defp build_query(query, []), do: query
  
end
