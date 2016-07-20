defmodule PortalApi.V1.LevelController do
  use PortalApi.Web, :controller

  alias PortalApi.Level

  plug :scrub_params, "level" when action in [:create, :update]

  def index(conn, params) do
    levels = Level
    |> build_level_query(Map.to_list(params))
    |> Repo.all

    render(conn, "index.json", levels: levels)
  end

  def create(conn, %{"level" => level_params}) do
    changeset = Level.changeset(%Level{}, level_params)

    case Repo.insert(changeset) do
      {:ok, level} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_level_path(conn, :show, level))
        |> render("show.json", level: level)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    level = Repo.get!(Level, id)
    render(conn, "show.json", level: level)
  end

  def update(conn, %{"id" => id, "level" => level_params}) do
    level = Repo.get!(Level, id)
    changeset = Level.changeset(level, level_params)

    case Repo.update(changeset) do
      {:ok, level} ->
        render(conn, "show.json", level: level)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    level = Repo.get!(Level, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(level)

    send_resp(conn, :no_content, "")
  end

  defp build_level_query(query, [{"program_id", program_id} | tail]) do
    query
    |> Ecto.Query.where([l], l.program_id == ^program_id)
    |> build_level_query(tail)
  end
  defp build_level_query(query, []), do: query
end
