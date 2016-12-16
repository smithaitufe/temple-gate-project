defmodule PortalApi.V1.FeeController do
  use PortalApi.Web, :controller

  alias PortalApi.Fee

  plug :scrub_params, "fee" when action in [:create, :update]

  def index(conn, params) do
    fees = Fee
    |> Ecto.Query.join(:inner, [f], fc in assoc(f, :fee_category))
    |> Ecto.Query.join(:inner, [f, fc], pc in assoc(f, :payer_category))    
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(Fee.associations)
    
    render(conn, "index.json", fees: fees)
  end

  def create(conn, %{"fee" => fee_params}) do
    changeset = Fee.changeset(%Fee{}, fee_params)

    case Repo.insert(changeset) do
      {:ok, fee} ->

        fee = fee |> Repo.preload(Fee.associations)


        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_fee_path(conn, :show, fee))
        |> render("show.json", fee: fee)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fee =  Fee
    |> Repo.get!(id)
    |> Repo.preload(Fee.associations)

    render(conn, "show.json", fee: fee)
  end

  def update(conn, %{"id" => id, "fee" => fee_params}) do
    fee = Repo.get!(Fee, id)
    changeset = Fee.changeset(fee, fee_params)

    case Repo.update(changeset) do
      {:ok, fee} ->
        fee = fee |> Repo.preload(Fee.associations)
        render(conn, "show.json", fee: fee)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fee = Repo.get!(Fee, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(fee)

    send_resp(conn, :no_content, "")
  end




  defp build_query(query, [{"program_id", program_id} |  tail]) do
    query
    |> Ecto.Query.where([f], f.program_id == ^program_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"level_id", level_id} |  tail]) do
    query
    |> Ecto.Query.where([f], f.level_id == ^level_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"is_all", is_all} |  tail]) do
    query
    |> Ecto.Query.where([f], f.is_all == ^is_all)
    |> build_query(tail)
  end
  defp build_query(query, [{"is_catchment", is_catchment} |  tail]) do
    query
    |> Ecto.Query.where([f], f.is_catchment == ^is_catchment)
    |> build_query(tail)
  end
  defp build_query(query, [{"payer_category_id", payer_category_id} |  tail]) do
    query

    |> Ecto.Query.where([f], f.payer_category_id == ^payer_category_id)
    |> build_query(tail)
  end

  defp build_query(query, [{"payer_category_id", payer_category_id} |  tail]) do
    query
    |> Ecto.Query.where([f], f.payer_category_id == ^payer_category_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"fee_category_id", fee_category_id} |  tail]) do
    query
    |> Ecto.Query.where([f], f.fee_category_id == ^fee_category_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"description", description} |  tail]) do
    query
    |> Ecto.Query.where([f], fragment("lower(?) = ?", f.description, type(^String.downcase(description), :string)))
    |> build_query(tail)
  end
  defp build_query(query, []), do: query



end
