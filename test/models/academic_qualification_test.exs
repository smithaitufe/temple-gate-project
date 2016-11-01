defmodule PortalApi.AcademicQualificationTest do
  use PortalApi.ModelCase

  alias PortalApi.AcademicQualification

  @valid_attrs %{user_id: 1, certificate_type_id: 1, course_studied: "some content", from: 42, school: "some content", to: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AcademicQualification.changeset(%AcademicQualification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AcademicQualification.changeset(%AcademicQualification{}, @invalid_attrs)
    refute changeset.valid?
  end
end
