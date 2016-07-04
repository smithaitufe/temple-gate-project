defmodule PortalApi.AcademicSessionTest do
  use PortalApi.ModelCase

  alias PortalApi.AcademicSession

  @valid_attrs %{closing_date: "2010-04-17 14:00:00", description: "some content", is_current: true, opening_date: "2010-04-17 14:00:00"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AcademicSession.changeset(%AcademicSession{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AcademicSession.changeset(%AcademicSession{}, @invalid_attrs)
    refute changeset.valid?
  end
end
