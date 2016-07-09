defmodule PortalApi.V1.UserRoleController do
  use PortalApi.Web, :controller

  alias PortalApi.UserRole

  plug :scrub_params, "user_role" when action in [:create, :update]

  def index(conn, _params) do
    user_roles = Repo.all(UserRole)
    render(conn, "index.json", user_roles: user_roles)
  end

  def create(conn, %{"user_role" => user_role_params}) do
    changeset = UserRole.changeset(%UserRole{}, user_role_params)

    case Repo.insert(changeset) do
      {:ok, user_role} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_user_role_path(conn, :show, user_role))
        |> render("show.json", user_role: user_role)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_role = Repo.get!(UserRole, id)
    render(conn, "show.json", user_role: user_role)
  end

  def update(conn, %{"id" => id, "user_role" => user_role_params}) do
    user_role = Repo.get!(UserRole, id)
    changeset = UserRole.changeset(user_role, user_role_params)

    case Repo.update(changeset) do
      {:ok, user_role} ->
        render(conn, "show.json", user_role: user_role)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_role = Repo.get!(UserRole, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_role)

    send_resp(conn, :no_content, "")
  end
end
