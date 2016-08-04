defmodule PortalApi.FacultyHeadTest do
  use PortalApi.ModelCase

  alias PortalApi.FacultyHead

  @valid_attrs %{active: true, appointment_date: "2010-04-17", effective_date: "2010-04-17", end_date: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FacultyHead.changeset(%FacultyHead{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FacultyHead.changeset(%FacultyHead{}, @invalid_attrs)
    refute changeset.valid?
  end
end
