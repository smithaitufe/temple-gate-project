defmodule PortalApi.V1.CurrentUserView do
  use PortalApi.Web, :view

  def render("show.json", %{user: user}) do
    %{data: %{
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        active: user.active
      }
    }
  end

  def render("error.json", _) do
  end
end
