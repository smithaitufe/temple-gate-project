defmodule PortalApi.StaffLeaveRequestTest do
  use PortalApi.ModelCase

  alias PortalApi.StaffLeaveRequest

  @valid_attrs %{approved: true, approved_end_date: "2010-04-17", approved_start_date: "2010-04-17", closed: true, closed_at: "2010-04-17 14:00:00", no_of_days: 42, proposed_end_date: "2010-04-17", proposed_start_date: "2010-04-17", read: true, rejected: true, rejection_reason: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StaffLeaveRequest.changeset(%StaffLeaveRequest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StaffLeaveRequest.changeset(%StaffLeaveRequest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
