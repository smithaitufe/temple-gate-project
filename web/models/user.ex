defmodule PortalApi.User do
  use PortalApi.Web, :model

  schema "users" do
    # field :last_name, :string
    # field :first_name, :string
    field :user_name, :string
    field :email, :string
    field :encrypted_password, :string
    belongs_to :user_category, PortalApi.Term

    field :password, :string, virtual: true


    has_one :student, PortalApi.Student, foreign_key: :user_id
    
    timestamps
  end

  @required_fields ~w(user_name email password user_category_id)
  @optional_fields ~w()

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

  defp encrypt_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} -> put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ -> current_changeset
    end
  end
end
