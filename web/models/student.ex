defmodule PortalApi.Student do
  use PortalApi.Web, :model

  # @primary_key {:id, :integer, autogenerate: false}
  schema "students" do


    field :first_name, :string, limit: 50, null: false
    field :last_name, :string, limit: 50, null: false
    field :middle_name, :string, limit: 50
    field :birth_date, Ecto.Date
    field :phone_number, :string
    field :email, :string
    field :registration_no, :string
    field :matriculation_no, :string
    field :admitted, :boolean, default: false

    belongs_to :gender, PortalApi.Term
    belongs_to :marital_status, PortalApi.Term
    belongs_to :academic_session, PortalApi.AcademicSession
    belongs_to :department, PortalApi.Department
    belongs_to :program, PortalApi.Program
    belongs_to :level, PortalApi.Level
    belongs_to :user, PortalApi.User
    belongs_to :entry_mode, PortalApi.Term
    belongs_to :local_government_area, PortalApi.LocalGovernmentArea

    has_one :student_program, PortalApi.StudentProgram
    has_many :student_courses, PortalApi.StudentCourse
    has_many :courses, through: [:student_courses, :course]
    has_many :student_certificates, PortalApi.StudentCertificate
    has_one :student_jamb_record, PortalApi.StudentJambRecord
    has_one :student_diploma_qualification, PortalApi.StudentDiplomaQualification

    has_many :student_payments, PortalApi.StudentPayment
    has_many :payments, through: [:student_payments, :payment]

    timestamps
  end

  @required_fields ~w(first_name last_name email program_id department_id academic_session_id entry_mode_id level_id)
  @optional_fields ~w(middle_name marital_status_id gender_id birth_date phone_number registration_no matriculation_no local_government_area_id admitted user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)

  end


  def associations do
    [
      {:program, [:levels]},
      {:department, [:faculty]},
      :level, :gender, :marital_status,:entry_mode,
      {:local_government_area, [:state]}
    ]
  end

end
