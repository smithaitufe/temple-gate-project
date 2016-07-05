defmodule PortalApi.Payment do
  use PortalApi.Web, :model

  schema "payments" do
    field :transaction_no, :string
    field :sub_total, :decimal
    field :service_charge, :decimal
    belongs_to :payment_status, PortalApi.Term

    timestamps
  end

  @required_fields ~w(payment_status_id transaction_no sub_total service_charge)
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
