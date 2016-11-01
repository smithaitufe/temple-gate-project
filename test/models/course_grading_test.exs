defmodule PortalApi.CourseGradingTest do
  use PortalApi.ModelCase

  alias PortalApi.CourseGrading

  @valid_attrs %{grade_point: "some content", letter: "some content", total: "120.5", weight: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CourseGrading.changeset(%CourseGrading{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CourseGrading.changeset(%CourseGrading{}, @invalid_attrs)
    refute changeset.valid?
  end
end
