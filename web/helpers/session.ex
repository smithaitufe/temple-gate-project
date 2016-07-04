defmodule ComputerBasedTest.Helper.Session do
  alias ComputerBasedTest.{Repo, User}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))
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
