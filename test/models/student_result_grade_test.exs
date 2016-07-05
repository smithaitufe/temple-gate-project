defmodule PortalApi.StudentResultGradeTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentResultGrade

  @valid_attrs %{grade: "some content", score: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentResultGrade.changeset(%StudentResultGrade{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentResultGrade.changeset(%StudentResultGrade{}, @invalid_attrs)
    refute changeset.valid?
  end
end
