defmodule PortalApi.PaymentItem do
  use PortalApi.Web, :model

  schema "payment_items" do
    field :amount, :decimal
    belongs_to :payment, PortalApi.Payment
    belongs_to :fee, PortalApi.Fee

    timestamps
  end

  @required_fields ~w(amount)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
