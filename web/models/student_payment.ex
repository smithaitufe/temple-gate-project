defmodule PortalApi.StudentPayment do
  use PortalApi.Web, :model

  schema "student_payments" do

    field :transaction_no, :string
    field :amount, :decimal
    field :service_charge, :decimal
    field :successful, :boolean, default: false
    belongs_to :student, PortalApi.Student
    belongs_to :fee, PortalApi.Fee
    belongs_to :payment_method, PortalApi.Term
    belongs_to :transaction_response, PortalApi.TransactionResponse
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(student_id academic_session_id fee_id amount service_charge payment_method_id transaction_response_id)
  @optional_fields ~w(transaction_no successful)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> generate_transaction_no
  end


  def associations do
    [
      {:student, [:program, {:department, [:faculty]}, :level, :marital_status, :gender]},
      :transaction_response, :academic_session, {:fee, [:level, {:program, [:levels]}] }, :payment_method
    ]
  end
  defp generate_transaction_no(changeset) do
    case get_change(changeset, :transaction_no) do
        nil ->
            :random.seed(:os.timestamp)
            transaction_no = Stream.repeatedly(fn -> trunc(:random.uniform * 10) end ) |> Enum.take(8) |> Enum.join
            put_change(changeset, :transaction_no, transaction_no)

        _ -> changeset
    end
  end

end
