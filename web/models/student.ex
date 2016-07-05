defmodule PortalApi.Student do
  use PortalApi.Web, :model

  schema "students" do
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :birth_date, Ecto.Date
    field :phone_number, :string
    field :email, :string
    field :registration_no, :string
    field :matriculation_no, :string
    belongs_to :gender, PortalApi.Gender
    belongs_to :marital_status, PortalApi.MaritalStatus
    belongs_to :academic_session, PortalApi.AcademicSession
    belongs_to :department, PortalApi.Department
    belongs_to :program, PortalApi.Program
    belongs_to :level, PortalApi.Level

    timestamps
  end

  @required_fields ~w(first_name last_name middle_name birth_date phone_number email registration_no matriculation_no)
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
