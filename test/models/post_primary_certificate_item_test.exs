defmodule PortalApi.PostPrimaryPostPrimaryCertificateItemTest do
  use PortalApi.ModelCase

  alias PortalApi.PostPrimaryCertificateItem

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PostPrimaryCertificateItem.changeset(%PostPrimaryCertificateItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostPrimaryCertificateItem.changeset(%PostPrimaryCertificateItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
