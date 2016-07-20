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
    }
    |> render_payment(%{payment: student_payment.payment})
    |> render_student(%{student: student_payment.student})
  end

  defp render_payment(json, %{payment: payment}) when is_map(payment) do
    Map.put(json, :payment, render_one(payment, PortalApi.V1.PaymentView, "payment.json"))
  end
  defp render_payment(json, _) do
    json
  end

  defp render_student(json, %{student: student}) when is_map(student) do
    Map.put(json, :student, render_one(student, PortalApi.V1.StudentView, "student.json"))
  end
  defp render_student(json, _) do
    json
  end
end
