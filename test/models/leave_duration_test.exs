defmodule PortalApi.LeaveDurationTest do
  use PortalApi.ModelCase

  alias PortalApi.LeaveDuration

  @valid_attrs %{duration: 42, maximum_grade_level: 42, minimum_grade_level: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LeaveDuration.changeset(%LeaveDuration{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LeaveDuration.changeset(%LeaveDuration{}, @invalid_attrs)
    refute changeset.valid?
  end
end
