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
    |> Map.put(:fee, render_one(payment.fee, PortalApi.V1.FeeView, "fee.json"))
    |> Map.put(:payment_method, render_one(payment.payment_method, PortalApi.V1.TermView, "term.json"))
    # |> Map.put(:payment_status, render_one(payment.payment_status, PortalApi.V1.TermView, "term.json"))
    |> Map.put(:transaction_response, render_one(payment.transaction_response, PortalApi.V1.TransactionResponseView, "transaction_response.json"))
    |> Map.put(:academic_session, render_one(payment.academic_session, PortalApi.V1.AcademicSessionView, "academic_session.json"))  

  end

  def render("payment_lite.json", %{payment: payment}) do
    %{
      id: payment.id,
      paid_by_user_id: payment.paid_by_user_id,
      transaction_no: payment.transaction_no,
      fee_id: payment.fee_id,
      amount: payment.amount,
      service_charge: payment.service_charge,
      payment_status_id: payment.payment_status_id,
      payment_method_id: payment.payment_method_id,
      transaction_response_id: payment.transaction_response_id,
      academic_session_id: payment.academic_session_id,
      inserted_at: payment.inserted_at,

      response_code: payment.response_code,
      response_description: payment.response_description,
      payment_reference_no: payment.payment_reference_no,
      merchant_reference_no: payment.merchant_reference_no
    }
  end
end
