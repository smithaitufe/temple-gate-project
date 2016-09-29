defmodule PortalApi.Staff do
  use Ecto.Schema
  import Ecto.Changeset

  schema "staffs" do
    field :registration_no, :string
    field :last_name, :string
    field :middle_name, :string
    field :first_name, :string
    field :birth_date, Ecto.Date
    belongs_to :marital_status, PortalApi.Term
    belongs_to :gender, PortalApi.Term
    belongs_to :local_government_area, PortalApi.LocalGovernmentArea
    belongs_to :user, PortalApi.User

    timestamps


    has_many :staff_postings, PortalApi.StaffPosting
    has_many :salary_grade_steps, through: [:staff_postings, :salary_grade_step]
    has_many :salary_grade_levels, through: [:salary_grade_steps, :salary_grade_level]


  end

  @required_fields ~w(last_name first_name)a
  @optional_fields ~w(user_id registration_no middle_name birth_date marital_status_id gender_id local_government_area_id)a

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

end
