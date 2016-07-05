defmodule PortalApi.V1.PaymentItemController do
  use PortalApi.Web, :controller

  alias PortalApi.PaymentItem

  plug :scrub_params, "payment_item" when action in [:create, :update]

  def index(conn, _params) do
    payment_items = Repo.all(PaymentItem)
    render(conn, "index.json", payment_items: payment_items)
  end

  def create(conn, %{"payment_item" => payment_item_params}) do
    changeset = PaymentItem.changeset(%PaymentItem{}, payment_item_params)

    case Repo.insert(changeset) do
      {:ok, payment_item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_payment_item_path(conn, :show, payment_item))
        |> render("show.json", payment_item: payment_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    payment_item = Repo.get!(PaymentItem, id)
    render(conn, "show.json", payment_item: payment_item)
  end

  def update(conn, %{"id" => id, "payment_item" => payment_item_params}) do
    payment_item = Repo.get!(PaymentItem, id)
    changeset = PaymentItem.changeset(payment_item, payment_item_params)

    case Repo.update(changeset) do
      {:ok, payment_item} ->
        render(conn, "show.json", payment_item: payment_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment_item = Repo.get!(PaymentItem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(payment_item)

    send_resp(conn, :no_content, "")
  end
end
