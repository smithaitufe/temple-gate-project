defmodule PortalApi.StudentResultTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentResult

  @valid_attrs %{number_failed: 42, number_passed: 42, promoted: true, total_point_average: "120.5", total_score: "120.5", total_units: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentResult.changeset(%StudentResult{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentResult.changeset(%StudentResult{}, @invalid_attrs)
    refute changeset.valid?
  end
end
