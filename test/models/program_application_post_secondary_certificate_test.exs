defmodule PortalApi.ProgramApplicationPostSecondaryCertificateTest do
  use PortalApi.ModelCase

  alias PortalApi.ProgramApplicationPostSecondaryCertificate

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProgramApplicationPostSecondaryCertificate.changeset(%ProgramApplicationPostSecondaryCertificate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProgramApplicationPostSecondaryCertificate.changeset(%ProgramApplicationPostSecondaryCertificate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
