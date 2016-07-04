defmodule PortalApi.Staff do
  use PortalApi.Web, :model

  schema "staffs" do
    field :registration_no, :string
    field :last_name, :string
    field :middle_name, :string
    field :first_name, :string
    field :birth_date, Ecto.Date
    belongs_to :marital_status, PortalApi.MaritalStatus
    belongs_to :gender, PortalApi.Gender
    belongs_to :local_government_area, PortalApi.LocalGovernmentArea

    timestamps
  end

  @required_fields ~w(registration_no last_name middle_name first_name birth_date)
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
