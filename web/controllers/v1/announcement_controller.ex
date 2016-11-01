defmodule PortalApi.V1.AnnouncementController do
  use PortalApi.Web, :controller

  alias PortalApi.Announcement

  plug :scrub_params, "announcement" when action in [:create, :update]

  def index(conn, _params) do
    announcements = Repo.all(Announcement)
    render(conn, "index.json", announcements: announcements)
  end

  def create(conn, %{"announcement" => announcement_params}) do
    changeset = Announcement.changeset(%Announcement{}, announcement_params)

    case Repo.insert(changeset) do
      {:ok, announcement} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_announcement_path(conn, :show, announcement))
        |> render("show.json", announcement: announcement)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement, id)
    render(conn, "show.json", announcement: announcement)
  end

  def update(conn, %{"id" => id, "announcement" => announcement_params}) do
    announcement = Repo.get!(Announcement, id)
    changeset = announcement.changeset(announcement, announcement_params)

    case Repo.update(changeset) do
      {:ok, announcement} ->
        render(conn, "show.json", announcement: announcement)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(announcement)

    send_resp(conn, :no_content, "")
  end
end
