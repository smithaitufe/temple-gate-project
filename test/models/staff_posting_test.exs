defmodule PortalApi.StaffPostingTest do
  use PortalApi.ModelCase

  alias PortalApi.StaffPosting

  @valid_attrs %{active: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StaffPosting.changeset(%StaffPosting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StaffPosting.changeset(%StaffPosting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
