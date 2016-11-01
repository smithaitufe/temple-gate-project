defmodule PortalApi.ProgramApplicationTest do
  use PortalApi.ModelCase

  alias PortalApi.ProgramApplication

  @valid_attrs %{active: true, admitted: true, person_id: 42, year: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProgramApplication.changeset(%ProgramApplication{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProgramApplication.changeset(%ProgramApplication{}, @invalid_attrs)
    refute changeset.valid?
  end
end
