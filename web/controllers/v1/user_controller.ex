defmodule PortalApi.V1.UserController do
  use PortalApi.Web, :controller
  plug :scrub_params, "user" when action in [:create]
  alias PortalApi.{Repo, User, UserRole, Term}

  def index(conn, _) do
    users = User
    |> Repo.all
    |> preload_models

    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User,id)
    render(conn, "show.json", user: user)
  end


  def create(conn, %{"user" => user_params}) do

    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, token, _full_claims} = Guardian.encode_and_sign(user, :token)

        conn
        |> put_status(:created)
        |> render(PortalApi.V1.SessionView, "show.json", user: user, token: token)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end






  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp preload_models(query) do
    query
    |> Repo.preload([:user_category])
  end


end
