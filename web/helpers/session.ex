defmodule PortalApi.Helper.Session do
  alias PortalApi.{Repo, User}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def authenticate(%{"user_name" => user_name, "password" => password}) do
    user = User
    |> User.load_user_category_and_roles
    |> Repo.get_by(user_name: String.downcase(user_name))
    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, :unsuccessful}
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> dummy_checkpw()
      _ -> checkpw(password, user.encrypted_password)
    end
  end
end
