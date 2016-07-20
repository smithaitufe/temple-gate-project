defmodule PortalApi.StudentPayment do
  use PortalApi.Web, :model

  schema "student_payments" do
    belongs_to :student, PortalApi.Student
    belongs_to :payment, PortalApi.Payment

    # Virtual fields
    field :transaction_no, :string, virtual: true
    field :amount, :decimal, virtual: true
    field :service_charge, :decimal, virtual: true
    field :fee_id, :integer, virtual: true
    field :payment_status_id, :integer, virtual: true
    field :payment_method_id, :integer, virtual: true
    field :transaction_response_id, :integer, virtual: true

    timestamps
  end

  @required_fields ~w(student_id payment_id)
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
