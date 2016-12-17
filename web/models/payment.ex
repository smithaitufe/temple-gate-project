defmodule PortalApi.Payment do
  use PortalApi.Web, :model

  schema "payments" do

    field :transaction_reference_no, :string
    field :amount, :decimal
    field :service_charge, :decimal
    field :successful, :boolean, default: false
    field :online, :boolean, default: false
    belongs_to :user, PortalApi.User, foreign_key: :user_id
    belongs_to :fee, PortalApi.Fee    
    belongs_to :academic_session, PortalApi.AcademicSession
    field :response_description, :string
    field :response_code, :string
    field :payment_reference_no, :string
    field :merchant_reference_no, :string
    field :receipt_no, :string
    field :payment_date, :string
    field :settlement_date, :string
    field :site_redirect_url, :string

    timestamps
  end

  @required_fields [:user_id, :academic_session_id, :fee_id, :amount, :service_charge, :payment_date]
  @optional_fields [:transaction_reference_no, :successful, :online, :receipt_no, :payment_reference_no, :merchant_reference_no, :response_code, :response_description, :settlement_date, :site_redirect_url]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
  def create_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> generate_transaction_reference_no()
  end

  def associations do
    [
      {
        :user, [
        {:profile, [:marital_status, :gender]},                
        ]
      },
      {:fee, [:payer_category, :fee_category, :level, {:program, [:levels]}] },
      :academic_session
    ]
  end
  defp generate_transaction_reference_no(changeset) do
    case get_change(changeset, :transaction_reference_no) do
        nil ->
            :random.seed(:os.timestamp)
            transaction_reference_no = Stream.repeatedly(fn -> trunc(:random.uniform * 10) end ) |> Enum.take(10) |> Enum.join
            put_change(changeset, :transaction_reference_no, transaction_reference_no)

        _ -> changeset
    end
  end

end
