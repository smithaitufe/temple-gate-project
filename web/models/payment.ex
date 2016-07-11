defmodule PortalApi.Payment do
  use PortalApi.Web, :model

  schema "payments" do
    field :transaction_no, :string
    field :amount, :decimal
    field :service_charge, :decimal

    belongs_to :fee, PortalApi.Fee
    belongs_to :payment_status, PortalApi.Term
    belongs_to :payment_method, PortalApi.Term
    belongs_to :transaction_response, PortalApi.TransactionResponse

    timestamps
  end

  @required_fields ~w(fee_id amount service_charge payment_method_id payment_status_id transaction_no transaction_response_id)
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
