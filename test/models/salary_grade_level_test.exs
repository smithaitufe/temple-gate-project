defmodule PortalApi.SalaryGradeLevelTest do
  use PortalApi.ModelCase

  alias PortalApi.SalaryGradeLevel

  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SalaryGradeLevel.changeset(%SalaryGradeLevel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SalaryGradeLevel.changeset(%SalaryGradeLevel{}, @invalid_attrs)
    refute changeset.valid?
  end
end
