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
    |> Map.put(:academic_session, render_one(payment.academic_session, PortalApi.V1.AcademicSessionView, "academic_session.json"))  

  end

  def render("payment_lite.json", %{payment: payment}) do
    %{
      id: payment.id,
      user_id: payment.user_id,
      transaction_reference_no: payment.transaction_reference_no,
      fee_id: payment.fee_id,
      amount: payment.amount,
      service_charge: payment.service_charge,     
      academic_session_id: payment.academic_session_id,
      inserted_at: payment.inserted_at,
      response_code: payment.response_code,
      response_description: payment.response_description,
      payment_reference_no: payment.payment_reference_no,
      merchant_reference_no: payment.merchant_reference_no,
      payment_date: payment.payment_date,
      settlement_date: payment.settlement_date,
      receipt_no: payment.receipt_no,
      online: payment.online,
      successful: payment.successful


    }
  end
end
