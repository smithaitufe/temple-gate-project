defmodule PortalApi.V1.ServiceChargeSplitController do
  use PortalApi.Web, :controller

  alias PortalApi.ServiceChargeSplit

  def index(conn, _params) do
    service_charge_splits = Repo.all(ServiceChargeSplit)
    render(conn, "index.json", service_charge_splits: service_charge_splits)
  end

  def create(conn, %{"service_charge_split" => service_charge_split_params}) do
    changeset = ServiceChargeSplit.changeset(%ServiceChargeSplit{}, service_charge_split_params)

    case Repo.insert(changeset) do
      {:ok, service_charge_split} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_service_charge_split_path(conn, :show, service_charge_split))
        |> render("show.json", service_charge_split: service_charge_split)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    service_charge_split = Repo.get!(ServiceChargeSplit, id)
    render(conn, "show.json", service_charge_split: service_charge_split)
  end

  def update(conn, %{"id" => id, "service_charge_split" => service_charge_split_params}) do
    service_charge_split = Repo.get!(ServiceChargeSplit, id)
    changeset = ServiceChargeSplit.changeset(service_charge_split, service_charge_split_params)

    case Repo.update(changeset) do
      {:ok, service_charge_split} ->
        render(conn, "show.json", service_charge_split: service_charge_split)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    service_charge_split = Repo.get!(ServiceChargeSplit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(service_charge_split)

    send_resp(conn, :no_content, "")
  end

  defp build_query_clauses(query, []), do: query
  defp build_query_clauses(query, [{"service_charge_id", service_charge_id}, tail ] do
    query
    |> Ecto.Query.where([service_charge_split], service_charge_split.service_charge_id == ^service_charge_id)
    |> build_query_clauses(tail)
  end
end
