defmodule PortalApi.User do
  use PortalApi.Web, :model

  schema "users" do

    field :user_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    field :confirmed, :boolean, default: false
    field :confirmation_code, :string
    field :locked, :boolean, default: false
    field :suspended, :boolean, default: false


    belongs_to :user_category, PortalApi.Term
    has_one :student, PortalApi.Student, foreign_key: :user_id

    has_many :user_roles, PortalApi.UserRole
    has_many :roles, through: [:user_roles, :role]

    timestamps
  end

  @required_fields ~w(user_name password user_category_id)
  @optional_fields ~w(email confirmed confirmation_code locked suspended)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
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


end
