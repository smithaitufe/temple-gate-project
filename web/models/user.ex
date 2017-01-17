defmodule PortalApi.User do
  use PortalApi.Web, :model

  schema "users" do
    field :last_name, :string
    field :first_name, :string    
    field :email, :string
    field :encrypted_password, :string    
    field :confirmed, :boolean, default: false
    field :confirmation_code, :string
    field :locked, :boolean, default: false
    field :suspended, :boolean, default: false
    field :password, :string, virtual: true


    

    has_one :profile, PortalApi.UserProfile, foreign_key: :user_id
    has_one :jamb_record, PortalApi.JambRecord, foreign_key: :user_id
    has_one :diploma_qualification, PortalApi.DiplomaQualification, foreign_key: :user_id   
    
    has_many :certificates, PortalApi.Certificate, foreign_key: :user_id
    has_many :program_applications, PortalApi.ProgramApplication, foreign_key: :user_id
    
    has_many :course_enrollments, PortalApi.CourseEnrollment, foreign_key: :user_id    
    has_many :courses, through: [:course_enrollments, :course]       
    has_many :payments, PortalApi.Payment, foreign_key: :user_id
    has_many :user_roles, PortalApi.UserRole, foreign_key: :user_id
    has_many :roles, through: [:user_roles, :role]
    

    has_many :postings, PortalApi.Posting, foreign_key: :user_id
    has_many :salary_grade_steps, through: [:postings, :salary_grade_step]
    has_many :salary_grade_levels, through: [:salary_grade_steps, :salary_grade_level]


    timestamps
  end

  @required_fields [:last_name, :first_name, :email, :password]
  @optional_fields [:confirmed, :confirmation_code, :locked, :suspended]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> encrypt_password
  end

  def load_user_category_and_roles(query) do
    from q in query,
    join: uc in assoc(q, :user_category),
    left_join: r in assoc(q, :roles),
    preload: [user_category: uc, roles: r]
  end

  defp encrypt_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} -> put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ -> current_changeset
    end
  end
  
  def associations do
    [:user_category]
  end

  def preload_student_associations do
    [
      :profile,
      {:program, [:levels]},
      {:department, [:faculty]},
      :level, :gender, :marital_status,:entry_mode,
      {:local_government_area, [:state]},
      :jamb_record, :diploma_qualification, :certificates,
      :program_applications, :course_enrollments, :courses, :payments,
      :roles, :user_roles
    ]
  end
  def staff_associations do
    [
      :profile,      
      
      :postings,
      :roles, :user_roles
    ]
  end




end
