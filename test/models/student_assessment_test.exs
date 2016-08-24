defmodule PortalApi.StudentAssessmentTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentAssessment

  @valid_attrs %{score: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentAssessment.changeset(%StudentAssessment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentAssessment.changeset(%StudentAssessment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
