defmodule PortalApi.V1.StudentPaymentController do
  use PortalApi.Web, :controller

  alias PortalApi.{Payment, StudentPayment}

  plug :scrub_params, "student_payment" when action in [:create, :update]

  def index(conn, params) do
    student_payments = StudentPayment
    |> build_student_payment_query(Map.to_list(params))
    |> Repo.all
    |> preload_models

    render(conn, "index.json", student_payments: student_payments)
  end

  def create(conn, %{"student_payment" => student_payment_params}) do
    changeset = StudentPayment.changeset(%StudentPayment{}, student_payment_params)

    case Repo.insert(changeset) do
      {:ok, student_payment} ->
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
    render(conn, "show.json", student_payment: student_payment)
  end

  def update(conn, %{"id" => id, "student_payment" => student_payment_params}) do
    student_payment = Repo.get!(StudentPayment, id)
    changeset = StudentPayment.changeset(student_payment, student_payment_params)

    case Repo.update(changeset) do
      {:ok, student_payment} ->
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

  defp build_student_payment_query(query, [{"student_id", student_id} | tail]) do
    query
    |> Ecto.Query.where([sp], sp.student_id == ^student_id)
    |> build_student_payment_query(tail)
  end
  defp build_student_payment_query(query, [{"level_id", level_id} | tail]) do
    query
    |> Ecto.Query.where([sp], sp.level_id == ^level_id)
    |> build_student_payment_query(tail)
  end
  defp build_student_payment_query(query, [{"fee_id", fee_id} | tail]) do
    query
    |> Ecto.Query.join(:left, [sp], p in assoc(sp, :payment))
    |> Ecto.Query.where([_, p], p.fee_id == ^fee_id)
    |> build_student_payment_query(tail)
  end
  defp build_student_payment_query(query, [{attr, value} | tail]), do: query
  defp build_student_payment_query(query, []), do: query
  # defp build_student_payment_query(query, [{attr, value} | tail]) do
  #   query
  #   |> Ecto.Query.where([sp], field(sp, ^String.to_existing_atom(attr)) == ^value)
  #   |> build_student_payment_query(tail)
  # end

  defp preload_models(model) do
    Repo.preload(model, [
      {:student, [:program, {:department, [:faculty, :department_type]}, :level, :marital_status, :gender]},
      {:payment, [:transaction_response, :academic_session, {:fee, [:level, :program] }, :payment_method, :payment_status]}
      ])
  end


end
