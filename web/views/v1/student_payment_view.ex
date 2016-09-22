defmodule PortalApi.V1.StudentPaymentView do
  use PortalApi.Web, :view

  def render("index.json", %{student_payments: student_payments}) do
    render_many(student_payments, PortalApi.V1.StudentPaymentView, "student_payment.json")
  end

  def render("show.json", %{student_payment: student_payment}) do
    render_one(student_payment, PortalApi.V1.StudentPaymentView, "student_payment.json")
  end

  def render("student_payment.json", %{student_payment: student_payment}) do
    render("student_payment_lite.json", student_payment: student_payment)
    |> Map.put(:fee, render_one(student_payment.fee, PortalApi.V1.FeeView, "fee.json"))
    |> Map.put(:payment_method, render_one(student_payment.payment_method, PortalApi.V1.TermView, "term.json"))
    |> Map.put(:transaction_response, render_one(student_payment.transaction_response, PortalApi.V1.TransactionResponseView, "transaction_response.json"))
    |> Map.put(:academic_session, render_one(student_payment.academic_session, PortalApi.V1.AcademicSessionView, "academic_session.json"))

  end

  def render("student_payment_lite.json", %{student_payment: student_payment}) do
    %{
      id: student_payment.id,
      transaction_no: student_payment.transaction_no,
      fee_id: student_payment.fee_id,
      amount: student_payment.amount,
      service_charge: student_payment.service_charge,
      payment_method_id: student_payment.payment_method_id,
      transaction_response_id: student_payment.transaction_response_id,
      academic_session_id: student_payment.academic_session_id,
      successful: student_payment.successful,
      inserted_at: student_payment.inserted_at
    }
  end
end
