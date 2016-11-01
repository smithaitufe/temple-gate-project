defmodule PortalApi.DirectEntryQualificationTest do
  use PortalApi.ModelCase

  alias PortalApi.DirectEntryQualification

  @valid_attrs %{cgpa: "120.5", course_studied: "some content", school: "some content", verified: true, verified_at: "2010-04-17 14:00:00", year_admitted: 42, year_graduated: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DirectEntryQualification.changeset(%DirectEntryQualification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DirectEntryQualification.changeset(%DirectEntryQualification{}, @invalid_attrs)
    refute changeset.valid?
  end
end
