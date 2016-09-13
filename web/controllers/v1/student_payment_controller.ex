defmodule PortalApi.V1.StudentPaymentController do
  use PortalApi.Web, :controller

  alias PortalApi.{Payment, StudentPayment}

  plug :scrub_params, "student_payment" when action in [:create, :update]

  def index(conn, params) do
    student_payments = StudentPayment
    |> Ecto.Query.join(:inner, [sp], f in assoc(sp, :fee))
    |> Ecto.Query.join(:inner, [sp, f], l in assoc(f, :level))
    |> Ecto.Query.join(:inner, [sp, f, l], fc in assoc(f, :fee_category))
    |> Ecto.Query.join(:inner, [sp, f, l, fc], pm in assoc(sp, :payment_method))
    |> Ecto.Query.join(:inner, [sp, f, l, fc, pm], tr in assoc(sp, :transaction_response))
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(StudentPayment.associations)

    render(conn, "index.json", student_payments: student_payments)
  end

  def create(conn, %{"student_payment" => student_payment_params}) do
    changeset = StudentPayment.changeset(%StudentPayment{}, student_payment_params)

    case Repo.insert(changeset) do
      {:ok, student_payment} ->

        student_payment = student_payment |> Repo.preload(StudentPayment.associations)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_payment_path(conn, :show, student_payment))
        |> render("show.json", student_payment: student_payment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_payment = Repo.get!(StudentPayment, id)
    |> Repo.preload(StudentPayment.associations)

    render(conn, "show.json", student_payment: student_payment)
  end

  def update(conn, %{"id" => id, "student_payment" => student_payment_params}) do
    student_payment = Repo.get!(StudentPayment, id)
    changeset = StudentPayment.changeset(student_payment, student_payment_params)

    case Repo.update(changeset) do
      {:ok, student_payment} ->

        student_payment = student_payment |> Repo.preload(StudentPayment.associations)
        render(conn, "show.json", student_payment: student_payment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_payment = Repo.get!(StudentPayment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_payment)

    send_resp(conn, :no_content, "")
  end

  defp build_query(query, [{"student_id", student_id} | tail]) do
    query
    |> Ecto.Query.where([sp], sp.student_id == ^student_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"level_id", level_id} | tail]) do
    query
    |> Ecto.Query.where([sp], sp.level_id == ^level_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"fee_description", fee_description} | tail]) do
    query
    |> Ecto.Query.join(:inner, [sp], f in assoc(sp, :fee))
    |> Ecto.Query.where([sp, f], fragment("lower(?) = ?", f.description, type(^String.downcase(fee_description), :string)))
    |> build_query(tail)
  end
  defp build_query(query, [{"fee_id", fee_id} | tail]) do
    query
    |> Ecto.Query.where([sp], sp.fee_id == ^fee_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"fee_category_id", fee_category_id} | tail]) do
    query
    |> Ecto.Query.where([f], f.fee_category_id == ^fee_category_id )
    |> build_query(tail)
  end
  defp build_query(query, [{"payment_method_id", payment_method_id} | tail]) do
    query
    |> Ecto.Query.where([sp, f], sp.payment_method_id == ^payment_method_id )
    |> build_query(tail)
  end
  defp build_query(query, [{"successful", successful} | tail]) do
    query
    |> Ecto.Query.where([sp, f], sp.successful == ^successful )
    |> build_query(tail)
  end
  defp build_query(query, [{"transaction_response", transaction_response} | tail]) do
    query
    |> Ecto.Query.join(:inner, [sp], tr in assoc(sp, :transaction_response))
    |> Ecto.Query.where([sp, tr], fragment("lower(?) = ?", tr.description, type(^String.downcase(transaction_response), :string)))
    |> build_query(tail)
  end
  defp build_query(query, [{attr, value} | tail]), do: query
  defp build_query(query, []), do: query





end
