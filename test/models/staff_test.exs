defmodule PortalApi.StaffTest do
  use PortalApi.ModelCase

  alias PortalApi.Staff

  @valid_attrs %{birth_date: "2010-04-17", first_name: "some content", last_name: "some content", middle_name: "some content", registration_no: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Staff.changeset(%Staff{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Staff.changeset(%Staff{}, @invalid_attrs)
    refute changeset.valid?
  end
end
