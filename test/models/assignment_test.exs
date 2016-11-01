defmodule PortalApi.AssignmentTest do
  use PortalApi.ModelCase

  alias PortalApi.Assignment

  @valid_attrs %{assigner_user_id: 1, course_id: 2, academic_session_id: 43, closing_date: "2010-04-17", closing_time: "14:00:00", note: "some content", question: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Assignment.changeset(%Assignment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Assignment.changeset(%Assignment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
