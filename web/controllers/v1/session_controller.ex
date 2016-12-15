defmodule PortalApi.V1.SessionController do
  use PortalApi.Web, :controller
  alias PortalApi.{Session, User}
  plug :scrub_params, "session" when action in [:create]


  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do   

        query = Repo.get_by(User, [email: String.downcase(email)])
        # query = from user in User,
        #         where: user.email == ^email, 
        #         select: user 

        # query = User |> Ecto.Query.where([user], user.email == ^String.downcase(email)) |> Repo.one

        case query do
          nil ->  
            Comeonin.Bcrypt.dummy_checkpw
            login_failed(conn)
          user -> check_password(conn, password, user)
        end        
     
  end
  defp check_password(conn, password, user) do
    if Comeonin.Bcrypt.checkpw(password, user.encrypted_password) do
          {:ok, token, _} = Guardian.encode_and_sign(user, :api)
          user = user |> Repo.preload([:roles, {:profile, PortalApi.UserProfile.associations}])
          render(conn, "show.json", user: user, token: token)
        else
          login_failed(conn)
        end
  end

  defp login_failed(conn) do
    conn
    |> render("error.json", %{})
    |> halt
  end

  def delete(conn, _) do
    {:ok, claims} = Guardian.Plug.claims(conn)

    conn
    |> Guardian.Plug.current_token
    |> Guardian.revoke!(claims)

    conn
    |> render("delete.json")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(PortalApi.V1.SessionView, "forbidden.json", error: "Not Authenticated")
  end
end
