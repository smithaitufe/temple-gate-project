defmodule PortalApi.Student do
  use PortalApi.Web, :model

  @primary_key {:id, :integer, autogenerate: false}
  schema "students" do


    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :birth_date, Ecto.Date
    field :phone_number, :string
    field :email, :string
    field :registration_no, :string
    field :matriculation_no, :string
    belongs_to :gender, PortalApi.Term
    belongs_to :marital_status, PortalApi.Term
    belongs_to :academic_session, PortalApi.AcademicSession
    belongs_to :department, PortalApi.Department
    belongs_to :program, PortalApi.Program
    belongs_to :level, PortalApi.Level
    belongs_to :user, PortalApi.User, define_field: false


    has_many :student_payments, PortalApi.StudentPayment
    has_many :payments, through: [:student_payments, :payment]

    has_many :student_courses, PortalApi.StudentCourse
    has_many :courses, through: [:student_courses, :course]


    timestamps
  end

  @required_fields ~w(id first_name last_name email registration_no program_id department_id)
  @optional_fields ~w(middle_name marital_status_id gender_id birth_date phone_number matriculation_no level_id)

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
