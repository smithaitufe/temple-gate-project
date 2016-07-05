defmodule PortalApi.V1.StudentPaymentView do
  use PortalApi.Web, :view

  def render("index.json", %{student_payments: student_payments}) do
    %{data: render_many(student_payments, PortalApi.V1.StudentPaymentView, "student_payment.json")}
  end

  def render("show.json", %{student_payment: student_payment}) do
    %{data: render_one(student_payment, PortalApi.V1.StudentPaymentView, "student_payment.json")}
  end

  def render("student_payment.json", %{student_payment: student_payment}) do
    %{id: student_payment.id,
      student_id: student_payment.student_id,
      payment_id: student_payment.payment_id,
      academic_session_id: student_payment.academic_session_id,
      level_id: student_payment.level_id}
  end
end
