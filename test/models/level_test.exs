defmodule PortalApi.LevelTest do
  use PortalApi.ModelCase

  alias PortalApi.Level

  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Level.changeset(%Level{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Level.changeset(%Level{}, @invalid_attrs)
    refute changeset.valid?
  end
end
