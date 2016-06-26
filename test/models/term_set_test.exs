defmodule PortalApi.TermSetTest do
  use PortalApi.ModelCase

  alias PortalApi.TermSet

  @valid_attrs %{display_name: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TermSet.changeset(%TermSet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TermSet.changeset(%TermSet{}, @invalid_attrs)
    refute changeset.valid?
  end
end
