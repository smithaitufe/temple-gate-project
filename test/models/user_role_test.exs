defmodule PortalApi.UserRoleTest do
  use PortalApi.ModelCase

  alias PortalApi.UserRole

  @valid_attrs %{default: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserRole.changeset(%UserRole{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserRole.changeset(%UserRole{}, @invalid_attrs)
    refute changeset.valid?
  end
end
