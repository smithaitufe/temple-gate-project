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
    belongs_to :academic_session, PortalApi.AcademicSession

    # has_many :student_payments, PortalApi.StudentPayment, foreign_key: :payment_id


    timestamps
  end

  @required_fields ~w(academic_session_id fee_id amount service_charge payment_method_id payment_status_id transaction_response_id)
  @optional_fields ~w(transaction_no)

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

  def load_associations(query) do
    fee_query = from f in PortalApi.Fee,
    join: p in assoc(f, :program),
    join: l in assoc(f, :level),
    preload: [program: p, level: l]

    from q in query,
    join: ps in assoc(q, :payment_status),
    join: pm in assoc(q, :payment_method),
    join: f in assoc(q, :fee),
    join: ac in assoc(q, :academic_session),
    left_join: tr in assoc(q, :transaction_response),

    preload: [transaction_response: tr, academic_session: ac, fee: ^fee_query, payment_method: pm, payment_status: ps]

  end

  def get_by_category(query, fee_category_id) do
    from [q, ps, pm, f] in query,
    where: f.fee_category_id == ^fee_category_id
  end

  defp generate_transaction_no(changeset) do
    case get_change(changeset, :registration_no) do
        nil ->
            :random.seed(:os.timestamp)
            transaction_no = Stream.repeatedly(fn -> trunc(:random.uniform * 10) end ) |> Enum.take(8) |> Enum.join
            put_change(changeset, :transaction_no, transaction_no)

        _ -> changeset
    end
  end

  def get_students_payments(query) do



  end
end
