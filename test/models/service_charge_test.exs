defmodule PortalApi.ServiceChargeTest do
  use PortalApi.ModelCase

  alias PortalApi.ServiceCharge

  @valid_attrs %{active: true, amount: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ServiceCharge.changeset(%ServiceCharge{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ServiceCharge.changeset(%ServiceCharge{}, @invalid_attrs)
    refute changeset.valid?
  end
end
