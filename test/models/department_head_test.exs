defmodule PortalApi.DepartmentHeadTest do
  use PortalApi.ModelCase

  alias PortalApi.DepartmentHead

  @valid_attrs %{active: true, appointment_date: "2010-04-17", effective_date: "2010-04-17", end_date: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DepartmentHead.changeset(%DepartmentHead{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DepartmentHead.changeset(%DepartmentHead{}, @invalid_attrs)
    refute changeset.valid?
  end
end
