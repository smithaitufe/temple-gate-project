defmodule PortalApi.V1.TransactionResponseController do
  use PortalApi.Web, :controller

  alias PortalApi.TransactionResponse

  plug :scrub_params, "transaction_response" when action in [:create, :update]

  def index(conn, _params) do
    transaction_responses = Repo.all(TransactionResponse)
    render(conn, "index.json", transaction_responses: transaction_responses)
  end

  def create(conn, %{"transaction_response" => transaction_response_params}) do
    changeset = TransactionResponse.changeset(%TransactionResponse{}, transaction_response_params)

    case Repo.insert(changeset) do
      {:ok, transaction_response} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_transaction_response_path(conn, :show, transaction_response))
        |> render("show.json", transaction_response: transaction_response)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction_response = Repo.get!(TransactionResponse, id)
    render(conn, "show.json", transaction_response: transaction_response)
  end

  def update(conn, %{"id" => id, "transaction_response" => transaction_response_params}) do
    transaction_response = Repo.get!(TransactionResponse, id)
    changeset = TransactionResponse.changeset(transaction_response, transaction_response_params)

    case Repo.update(changeset) do
      {:ok, transaction_response} ->
        render(conn, "show.json", transaction_response: transaction_response)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction_response = Repo.get!(TransactionResponse, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(transaction_response)

    send_resp(conn, :no_content, "")
  end
end
