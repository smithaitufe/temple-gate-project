defmodule PortalApi.StudentContinuousAssessmentTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentContinuousAssessment

  @valid_attrs %{score: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentContinuousAssessment.changeset(%StudentContinuousAssessment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentContinuousAssessment.changeset(%StudentContinuousAssessment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
