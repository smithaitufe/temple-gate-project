defmodule PortalApi.StudentAssignmentTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentAssignment

  @valid_attrs %{submission: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentAssignment.changeset(%StudentAssignment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentAssignment.changeset(%StudentAssignment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
