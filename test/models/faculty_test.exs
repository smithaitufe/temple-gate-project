defmodule PortalApi.FacultyTest do
  use PortalApi.ModelCase

  alias PortalApi.Faculty

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Faculty.changeset(%Faculty{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Faculty.changeset(%Faculty{}, @invalid_attrs)
    refute changeset.valid?
  end
end
