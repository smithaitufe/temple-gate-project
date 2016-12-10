defmodule PortalApi.V1.UserController do
  use PortalApi.Web, :controller
  plug :scrub_params, "user" when action in [:create]
  alias PortalApi.{Repo, User, UserRole, Term}
  # plug Guardian.Plug.EnsureAuthenticated, %{ on_failure: { PortalApi.V1.SessionController, :new } } when not action in [:new, :create]

  def index(conn, params) do
    users = User
    |> build_query(Map.to_list(params))
    |> Repo.all  

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
        user = user |> Repo.preload([:roles])
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_user_path(conn, :show, user))
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
        user = user |> Repo.preload(User.associations)
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp build_query(query, [{"email", email} | tail]) do
    query
    |> Ecto.Query.where([user], user.email == ^email)
    |> build_query(tail)
  end
  defp build_query(query, []), do: query



end
