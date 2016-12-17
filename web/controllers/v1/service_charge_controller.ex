defmodule PortalApi.V1.ServiceChargeController do
  use PortalApi.Web, :controller

  alias PortalApi.ServiceCharge

  def index(conn, params) do
    service_charges = ServiceCharge
    |> build_query_clauses(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(ServiceCharge.associations)

    render(conn, "index.json", service_charges: service_charges)
  end

  def create(conn, %{"service_charge" => service_charge_params}) do
    changeset = ServiceCharge.changeset(%ServiceCharge{}, service_charge_params)

    case Repo.insert(changeset) do
      {:ok, service_charge} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_service_charge_path(conn, :show, service_charge))
        |> render("show.json", service_charge: service_charge)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    service_charge = Repo.get!(ServiceCharge, id)
    render(conn, "show.json", service_charge: service_charge)
  end

  def update(conn, %{"id" => id, "service_charge" => service_charge_params}) do
    service_charge = Repo.get!(ServiceCharge, id)
    changeset = ServiceCharge.changeset(service_charge, service_charge_params)

    case Repo.update(changeset) do
      {:ok, service_charge} ->
        render(conn, "show.json", service_charge: service_charge)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    service_charge = Repo.get!(ServiceCharge, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(service_charge)

    send_resp(conn, :no_content, "")
  end

  defp build_query_clauses(query, []), do: query
  defp build_query_clauses(query, [{"program_id", program_id} | tail ]) do
    query
    |> Ecto.Query.where([service_charge], service_charge.program_id == ^program_id)
    |> build_query_clauses(tail)
  end
  defp build_query_clauses(query, [{"payer_category_id", payer_category_id} | tail ]) do
    query
    |> Ecto.Query.where([service_charge], service_charge.payer_category_id == ^payer_category_id)
    |> build_query_clauses(tail)
  end
end