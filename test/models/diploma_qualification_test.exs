defmodule PortalApi.DiplomaQualificationTest do
  use PortalApi.ModelCase

  alias PortalApi.DiplomaQualification

  @valid_attrs %{cgpa: "120.5", course: "some content", school: "some content", year_graduated: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DiplomaQualification.changeset(%DiplomaQualification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DiplomaQualification.changeset(%DiplomaQualification{}, @invalid_attrs)
    refute changeset.valid?
  end
end
