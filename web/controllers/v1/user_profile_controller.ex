defmodule PortalApi.V1.UserProfileController do
  use PortalApi.Web, :controller

  alias PortalApi.UserProfile

  plug :scrub_params, "user_proflle" when action in [:create, :update]

  def index(conn, params) do
    user_profiles = UserProfile    
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(preload_associations)
    render(conn, "index.json", user_profiles: user_profiles)
  end

  def create(conn, %{"user_profile" => user_profile_params}) do
    changeset = UserProfile.changeset(%UserProfile{}, user_profile_params)

    case Repo.insert(changeset) do
      {:ok, user_profile} ->
        user_profile = user_profile |> Repo.preload(preload_associations)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_user_profile_path(conn, :show, user_profile))
        |> render("show.json", user_profile: user_profile)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_profile = Repo.get!(UserProfile, id) |> Repo.preload(preload_associations)
    render(conn, "show.json", user_profile: user_profile)
  end

  def update(conn, %{"id" => id, "user_profile" => user_profile_params}) do
    user_profile = Repo.get!(UserProfile, id)
    changeset = UserProfile.changeset(user_profile, user_profile_params)

    case Repo.update(changeset) do
      {:ok, user_profile} ->
        user_profile = Repo.preload(user_profile, preload_associations)
        render(conn, "show.json", user_profile: user_profile)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_profile = Repo.get!(UserProfile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_profile)

    send_resp(conn, :no_content, "")
  end



  defp preload_associations do
    [:marital_status, {:local_government_area, :state}, :gender]
  end

  defp build_query(query, [{ "user_id", user_id } | tail]) do
      query
      |> Ecto.Query.where([user_profile], user_profile.user_id == ^user_id)
      |> build_query(tail)
  end
  defp build_query(query, []), do: query

end
