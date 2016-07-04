defmodule PortalApi.ProgramTest do
  use PortalApi.ModelCase

  alias PortalApi.Program

  @valid_attrs %{description: "some content", duration: 42, name: "some content", text: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Program.changeset(%Program{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Program.changeset(%Program{}, @invalid_attrs)
    refute changeset.valid?
  end
end
