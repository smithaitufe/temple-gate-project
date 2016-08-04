defmodule PortalApi.V1.PaymentView do
  use PortalApi.Web, :view

  def render("index.json", %{payments: payments}) do
    render_many(payments, PortalApi.V1.PaymentView, "payment.json")
  end

  def render("show.json", %{payment: payment}) do
    render_one(payment, PortalApi.V1.PaymentView, "payment.json")
  end

  def render("payment.json", %{payment: payment}) do
    render("payment_lite.json", payment: payment)
    |> render_fee(%{fee: payment.fee})
    |> render_payment_method(%{payment_method: payment.payment_method})
    |> render_payment_status(%{payment_status: payment.payment_status})
    |> render_transaction_response(%{transaction_response: payment.transaction_response})
    |> render_academic_session(%{academic_session: payment.academic_session})

  end

  def render("payment_lite.json", %{payment: payment}) do
    %{
      id: payment.id,
      transaction_no: payment.transaction_no,
      fee_id: payment.fee_id,
      amount: payment.amount,
      service_charge: payment.service_charge,
      payment_status_id: payment.payment_status_id,
      payment_method_id: payment.payment_method_id,
      transaction_response_id: payment.transaction_response_id,
      academic_session_id: payment.academic_session_id,
      inserted_at: payment.inserted_at
    }
  end




  defp render_fee(json, %{fee: fee}) when is_map(fee) do
    Map.put(json, :fee, render_one(fee, PortalApi.V1.FeeView, "fee.json"))
  end
  defp render_fee(json, _) do
    json
  end

  defp render_payment_method(json, %{payment_method: payment_method}) when is_map(payment_method) do
    Map.put(json, :payment_method, render_one(payment_method, PortalApi.V1.TermView, "term.json"))
  end
  defp render_payment_method(json, _) do
    json
  end

  defp render_payment_status(json, %{payment_status: payment_status}) when is_map(payment_status) do
    Map.put(json, :payment_status, render_one(payment_status, PortalApi.V1.TermView, "term.json"))
  end
  defp render_payment_status(json, _) do
    json
  end

  defp render_transaction_response(json, %{transaction_response: transaction_response}) when is_map(transaction_response) do
    Map.put(json, :transaction_response, render_one(transaction_response, PortalApi.V1.TransactionResponseView, "transaction_response.json"))
  end
  defp render_transaction_response(json, _) do
    json
  end
  defp render_academic_session(json, %{academic_session: academic_session}) when is_map(academic_session) do
    Map.put(json, :academic_session, render_one(academic_session, PortalApi.V1.AcademicSessionView, "academic_session.json"))
  end
  defp render_academic_session(json, _) do
    json
  end


end
