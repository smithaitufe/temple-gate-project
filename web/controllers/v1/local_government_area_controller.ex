defmodule PortalApi.V1.LocalGovernmentAreaController do
  use PortalApi.Web, :controller

  alias PortalApi.LocalGovernmentArea

  plug :scrub_params, "local_government_area" when action in [:create, :update]

  def index(conn, params) do
    local_government_areas = LocalGovernmentArea
    |> build_local_government_area_query(Map.to_list(params))
    |> Repo.all
    
    render(conn, "index.json", local_government_areas: local_government_areas)
  end

  def create(conn, %{"local_government_area" => local_government_area_params}) do
    changeset = LocalGovernmentArea.changeset(%LocalGovernmentArea{}, local_government_area_params)

    case Repo.insert(changeset) do
      {:ok, local_government_area} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_local_government_area_path(conn, :show, local_government_area))
        |> render("show.json", local_government_area: local_government_area)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    local_government_area = Repo.get!(LocalGovernmentArea, id)
    render(conn, "show.json", local_government_area: local_government_area)
  end

  def update(conn, %{"id" => id, "local_government_area" => local_government_area_params}) do
    local_government_area = Repo.get!(LocalGovernmentArea, id)
    changeset = LocalGovernmentArea.changeset(local_government_area, local_government_area_params)

    case Repo.update(changeset) do
      {:ok, local_government_area} ->
        render(conn, "show.json", local_government_area: local_government_area)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    local_government_area = Repo.get!(LocalGovernmentArea, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(local_government_area)

    send_resp(conn, :no_content, "")
  end

  defp build_local_government_area_query(query, []), do: query
  defp build_local_government_area_query(query, [{"state_id", state_id} | tail ]) do
    query
    |> Ecto.Query.where([l], l.state_id == ^state_id)
    |> build_local_government_area_query(tail)
  end
end
