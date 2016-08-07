defmodule PortalApi.CourseTutorTest do
  use PortalApi.ModelCase

  alias PortalApi.CourseTutor

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CourseTutor.changeset(%CourseTutor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CourseTutor.changeset(%CourseTutor{}, @invalid_attrs)
    refute changeset.valid?
  end
end
