defmodule PortalApi.StudentCertificateSubjectGradeTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentCertificateSubjectGrade

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentCertificateSubjectGrade.changeset(%StudentCertificateSubjectGrade{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentCertificateSubjectGrade.changeset(%StudentCertificateSubjectGrade{}, @invalid_attrs)
    refute changeset.valid?
  end
end
