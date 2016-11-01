defmodule PortalApi.CertificateItemTest do
  use PortalApi.ModelCase

  alias PortalApi.CertificateItem

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CertificateItem.changeset(%CertificateItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CertificateItem.changeset(%CertificateItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
