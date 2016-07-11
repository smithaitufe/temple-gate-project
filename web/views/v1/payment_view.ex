defmodule PortalApi.V1.PaymentView do
  use PortalApi.Web, :view

  def render("index.json", %{payments: payments}) do
    %{data: render_many(payments, PortalApi.V1.PaymentView, "payment.json")}
  end

  def render("show.json", %{payment: payment}) do
    %{data: render_one(payment, PortalApi.V1.PaymentView, "payment.json")}
  end

  def render("payment.json", %{payment: payment}) do
    %{id: payment.id,
      transaction_no: payment.transaction_no,
      fee_id: payment.fee_id,
      amount: payment.amount,
      service_charge: payment.service_charge,
      payment_status_id: payment.payment_status_id,
      payment_method_id: payment.payment_method_id,      
      transaction_response_id: payment.transaction_response_id,
      inserted_at: payment.inserted_at
    }
  end
end
