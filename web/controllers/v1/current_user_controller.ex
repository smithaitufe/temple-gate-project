defmodule PortalApi.V1.CurrentUserController do
  use PortalApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: PortalApi.V1.SessionController

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    user = user |> Repo.preload([:user_category, :roles])
    conn
    |> put_status(:ok)
    |> render("show.json", user: user)
  end
end
