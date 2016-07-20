defmodule PortalApi.StudentCertificateTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentCertificate

  @valid_attrs %{registration_no: "some content", year_obtained: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentCertificate.changeset(%StudentCertificate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentCertificate.changeset(%StudentCertificate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
