defmodule PortalApi.ServiceChargeSplitTest do
  use PortalApi.ModelCase

  alias PortalApi.ServiceChargeSplit

  @valid_attrs %{account: "some content", amount: "120.5", bank_code: "some content", name: "some content", required: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ServiceChargeSplit.changeset(%ServiceChargeSplit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ServiceChargeSplit.changeset(%ServiceChargeSplit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
