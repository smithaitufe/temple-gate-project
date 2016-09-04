defmodule PortalApi.StudentCertificateItemTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentCertificateItem

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentCertificateItem.changeset(%StudentCertificateItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentCertificateItem.changeset(%StudentCertificateItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
