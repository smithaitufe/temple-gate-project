defmodule PortalApi.StaffLeaveEntitlementTest do
  use PortalApi.ModelCase

  alias PortalApi.StaffLeaveEntitlement

  @valid_attrs %{entitled_leave: "some content", remaining_leave: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StaffLeaveEntitlement.changeset(%StaffLeaveEntitlement{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StaffLeaveEntitlement.changeset(%StaffLeaveEntitlement{}, @invalid_attrs)
    refute changeset.valid?
  end
end
