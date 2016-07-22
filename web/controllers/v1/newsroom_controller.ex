defmodule PortalApi.V1.NewsroomController do
  use PortalApi.Web, :controller

  alias PortalApi.Newsroom

  plug :scrub_params, "newsroom" when action in [:create, :update]

  def index(conn, _params) do
    newsrooms = Repo.all(Newsroom)
    render(conn, "index.json", newsrooms: newsrooms)
  end

  def create(conn, %{"newsroom" => newsroom_params}) do
    changeset = Newsroom.changeset(%Newsroom{}, newsroom_params)

    case Repo.insert(changeset) do
      {:ok, newsroom} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_newsroom_path(conn, :show, newsroom))
        |> render("show.json", newsroom: newsroom)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    newsroom = Repo.get!(Newsroom, id)
    render(conn, "show.json", newsroom: newsroom)
  end

  def update(conn, %{"id" => id, "newsroom" => newsroom_params}) do
    newsroom = Repo.get!(Newsroom, id)
    changeset = Newsroom.changeset(newsroom, newsroom_params)

    case Repo.update(changeset) do
      {:ok, newsroom} ->
        render(conn, "show.json", newsroom: newsroom)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    newsroom = Repo.get!(Newsroom, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(newsroom)

    send_resp(conn, :no_content, "")
  end
end
