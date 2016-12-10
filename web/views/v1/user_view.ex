defmodule PortalApi.V1.UserView do
  use PortalApi.Web, :view

  def render("index.json", %{users: users}) do
    render_many(users, PortalApi.V1.UserView, "user.json")
  end
  def render("show.json", %{user: user}) do
    render_one(user, PortalApi.V1.UserView, "user.json")
  end
  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,      
      email: user.email      
    }
    
  end
  def render("error.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{} |> Map.put(field, render_detail(detail))
    end)

    %{
      errors: errors
    }
  end
  def render("examinee_uploaded.json", _) do
    %{ok: true}
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc -> String.replace(acc, "%{#{k}}", to_string(v)) end)
  end

  defp render_detail(message) do
    message
  end

end
