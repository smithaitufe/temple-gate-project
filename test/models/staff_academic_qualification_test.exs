defmodule PortalApi.StaffAcademicQualificationTest do
  use PortalApi.ModelCase

  alias PortalApi.StaffAcademicQualification

  @valid_attrs %{course_studied: "some content", from: 42, school: "some content", to: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StaffAcademicQualification.changeset(%StaffAcademicQualification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StaffAcademicQualification.changeset(%StaffAcademicQualification{}, @invalid_attrs)
    refute changeset.valid?
  end
end
