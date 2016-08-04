defmodule PortalApi.V1.RoleView do
  use PortalApi.Web, :view

  def render("index.json", %{roles: roles}) do
    %{data: render_many(roles, PortalApi.V1.RoleView, "role.json")}
  end

  def render("show.json", %{role: role}) do
    %{data: render_one(role, PortalApi.V1.RoleView, "role.json")}
  end

  def render("role.json", %{role: role}) do
    %{id: role.id,
      name: role.name,
      description: role.description,
      slug: role.slug}
  end
end
