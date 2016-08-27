defmodule PortalApi.StudentCourseGradingTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentCourseGrading

  @valid_attrs %{grade_point: "some content", letter: "some content", total: "120.5", weight: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentCourseGrading.changeset(%StudentCourseGrading{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentCourseGrading.changeset(%StudentCourseGrading{}, @invalid_attrs)
    refute changeset.valid?
  end
end
