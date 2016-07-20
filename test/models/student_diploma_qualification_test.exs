defmodule PortalApi.StudentDiplomaQualificationTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentDiplomaQualification

  @valid_attrs %{cgpa: "120.5", course: "some content", school: "some content", year_graduated: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentDiplomaQualification.changeset(%StudentDiplomaQualification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentDiplomaQualification.changeset(%StudentDiplomaQualification{}, @invalid_attrs)
    refute changeset.valid?
  end
end
