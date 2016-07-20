defmodule PortalApi.ProgramAdvertTest do
  use PortalApi.ModelCase

  alias PortalApi.ProgramAdvert

  @valid_attrs %{active: true, closing_date: "2010-04-17", opening_date: "2010-04-17"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProgramAdvert.changeset(%ProgramAdvert{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProgramAdvert.changeset(%ProgramAdvert{}, @invalid_attrs)
    refute changeset.valid?
  end
end
