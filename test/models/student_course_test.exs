defmodule PortalApi.StudentCourseTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentCourse

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentCourse.changeset(%StudentCourse{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentCourse.changeset(%StudentCourse{}, @invalid_attrs)
    refute changeset.valid?
  end
end
