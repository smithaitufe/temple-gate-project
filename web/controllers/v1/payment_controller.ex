defmodule PortalApi.V1.PaymentController do
  use PortalApi.Web, :controller

  alias PortalApi.Payment

  plug :scrub_params, "payment" when action in [:create, :update]

  def index(conn, %{ "type" => "student", "params" => params } = all) do
    send_resp(conn, :content, params)
  end

  # def index(conn, _params) do
  #   payments = Payment
  #   |> Payment.load_associations
  #   |> Repo.all
  #
  #   render(conn, "index.json", payments: payments)
  # end

  def create(conn, %{"payment" => payment_params}) do
    changeset = Payment.changeset(%Payment{}, payment_params)

    case Repo.insert(changeset) do
      {:ok, payment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_payment_path(conn, :show, payment))
        |> render("show.json", payment: payment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Repo.get!(Payment, id)
    render(conn, "show.json", payment: payment)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Repo.get!(Payment, id)
    changeset = Payment.changeset(payment, payment_params)

    case Repo.update(changeset) do
      {:ok, payment} ->
        render(conn, "show.json", payment: payment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Repo.get!(Payment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(payment)

    send_resp(conn, :no_content, "")
  end

  def get_payments_by_category(conn, %{"fee_category_id" => fee_category_id}) do
    payments = Payment
    |> Payment.load_associations
    |> Payment.get_by_category(fee_category_id)
    |> Repo.all

    render(conn, "index.json", payments: payments)
  end
end
