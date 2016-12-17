defmodule PortalApi.V1.PaymentController do
  use PortalApi.Web, :controller
  alias PortalApi.Payment

  plug :scrub_params, "payment" when action in [:create, :update]

  def index(conn, params) do
    payments = Payment
    |> Ecto.Query.join(:inner, [sp], f in assoc(sp, :fee))    
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(Payment.associations)

    render(conn, "index.json", payments: payments)
  end

  def create(conn, %{"payment" => payment_params}) do
    changeset = Payment.create_changeset(%Payment{}, payment_params)    
    case Repo.insert(changeset) do
      {:ok, payment} ->
        IO.inspect payment
        payment = payment |> Repo.preload(Payment.associations)
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
    payment = Repo.get!(Payment, id) |> Repo.preload(Payment.associations)

    render(conn, "show.json", payment: payment)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Repo.get!(Payment, id)
    changeset = Payment.changeset(payment, payment_params)

    case Repo.update(changeset) do
      {:ok, payment} ->

        payment = payment |> Repo.preload(Payment.associations)
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

  defp build_query(query, [{"academic_session_id", academic_session_id} | tail]) do
    query
    |> Ecto.Query.where([p], p.academic_session_id == ^academic_session_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"transaction_reference_no", transaction_reference_no} | tail]) do
    query
    |> Ecto.Query.where([p], p.transaction_reference_no == ^transaction_reference_no)
    |> build_query(tail)
  end
  defp build_query(query, [{"user_id", user_id} | tail]) do
    query
    |> Ecto.Query.where([p], p.user_id == ^user_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"level_id", level_id} | tail]) do
    query
    |> Ecto.Query.where([p], p.level_id == ^level_id)
    |> build_query(tail)
  end  
  defp build_query(query, [{"fee_id", fee_id} | tail]) do
    query
    |> Ecto.Query.where([p, f], p.fee_id == ^fee_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"fee_category_id", fee_category_id} | tail]) do
    query
    |> Ecto.Query.where([p, f], f.fee_category_id == ^fee_category_id )
    |> build_query(tail)
  end
  defp build_query(query, [{"online", online} | tail]) do
    query
    |> Ecto.Query.where([p, f], p.online == ^online )
    |> build_query(tail)
  end
  defp build_query(query, [{"successful", successful} | tail]) do
    query
    |> Ecto.Query.where([p, f], p.successful == ^successful )
    |> build_query(tail)
  end
  defp build_query(query, []), do: query

end