defmodule PortalApi.ProgramApplication do
  use PortalApi.Web, :model

  schema "program_applications" do
    
    field :registration_no, :string
    field :matriculation_no, :string    
    field :is_admitted, :boolean, default: false
    field :active, :boolean, default: true
    field :completed, :boolean, default: false
    belongs_to :user, PortalApi.User, foreign_key: :user_id
    belongs_to :program, PortalApi.Program, foreign_key: :program_id
    belongs_to :department, PortalApi.Department, foreign_key: :department_id
    belongs_to :level, PortalApi.Level, foreign_key: :level_id
    belongs_to :entry_mode, PortalApi.Term, foreign_key: :entry_mode_id
    belongs_to :academic_session, PortalApi.AcademicSession, foreign_key: :academic_session_id


    has_one :program_application_post_secondary_certificate, PortalApi.ProgramApplicationPostSecondaryCertificate
    has_one :post_secondary_certificate, through:  [:program_application_post_secondary_certificate, :post_secondary_certificate]
    
    has_one :program_application_jamb_record, PortalApi.ProgramApplicationJambRecord
    has_one :jamb_record, through:  [:program_application_jamb_record, :jamb_record]

    timestamps()
  end
  @required_fields [:user_id, :program_id, :department_id, :level_id, :entry_mode_id, :academic_session_id]
  @optional_fields [:registration_no, :matriculation_no, :is_admitted, :active, :completed]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    
  end

  def associations do
    [{:program, [:levels]},{ :department, [:faculty]}, :level, :entry_mode, :academic_session, :jamb_record, :post_secondary_certificate]
  end

end
