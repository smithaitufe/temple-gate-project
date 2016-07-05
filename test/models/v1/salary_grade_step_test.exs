defmodule PortalApi.V1.SalaryGradeStepTest do
  use PortalApi.ModelCase

  alias PortalApi.V1.SalaryGradeStep

  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SalaryGradeStep.changeset(%SalaryGradeStep{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SalaryGradeStep.changeset(%SalaryGradeStep{}, @invalid_attrs)
    refute changeset.valid?
  end
end
