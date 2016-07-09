defmodule PortalApi.V1.SessionView do
  use PortalApi.Web, :view
  def render("show.json", %{jwt: jwt, user: user, roles: roles}) do
    %{data:
      %{
        user: %{
          id: user.id,
          user_name: user.user_name,
          email: user.email,
          user_category_id: user.user_category_id
        },
        jwt: jwt
      }
      |> render_roles(%{roles: roles})
    }
  end
  def render("show.json", %{jwt: jwt, user: user}) do
    %{data:
      %{
        user: %{
          id: user.id,
          user_name: user.user_name,
          email: user.email,
          user_category_id: user.user_category_id
        },
        jwt: jwt
      }

    }
  end


  defp render_roles(json, %{roles: roles}) do
    Map.put(json, :roles, render_many(roles, PortalApi.V1.TermView, "term.json"))
  end

  def render("error.json", _) do
    %{error: "Invalid email or password"}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end
