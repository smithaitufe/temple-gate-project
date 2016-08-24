defmodule PortalApi.StudentCourseAssessmentTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentCourseAssessment

  @valid_attrs %{score: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentCourseAssessment.changeset(%StudentCourseAssessment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentCourseAssessment.changeset(%StudentCourseAssessment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
