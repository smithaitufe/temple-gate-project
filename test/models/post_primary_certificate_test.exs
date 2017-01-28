defmodule PortalApi.PostPrimaryCertificateTest do
  use PortalApi.ModelCase

  alias PortalApi.PostPrimaryCertificate

  @valid_attrs %{user_id: 2, registration_no: "some content", year_obtained: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PostPrimaryCertificate.changeset(%PostPrimaryCertificate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostPrimaryCertificate.changeset(%PostPrimaryCertificate{}, @invalid_attrs)
    refute changeset.valid?
  end
end