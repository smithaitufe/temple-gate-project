defmodule PortalApi.CertificateTest do
  use PortalApi.ModelCase

  alias PortalApi.Certificate

  @valid_attrs %{user_id: 2, registration_no: "some content", year_obtained: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Certificate.changeset(%Certificate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Certificate.changeset(%Certificate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
