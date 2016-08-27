defmodule PortalApi.GradeChangeRequestTest do
  use PortalApi.ModelCase

  alias PortalApi.GradeChangeRequest

  @valid_attrs %{aapproved: true, approved_at: "2010-04-17 14:00:00", current_grade_letter: "some content", current_score: "120.5", previous_grade_letter: "some content", previous_score: "120.5", read: true, rejected: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GradeChangeRequest.changeset(%GradeChangeRequest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GradeChangeRequest.changeset(%GradeChangeRequest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
