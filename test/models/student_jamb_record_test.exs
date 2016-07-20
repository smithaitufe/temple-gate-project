defmodule PortalApi.StudentJambRecordTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentJambRecord

  @valid_attrs %{registration_no: "some content", score: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentJambRecord.changeset(%StudentJambRecord{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentJambRecord.changeset(%StudentJambRecord{}, @invalid_attrs)
    refute changeset.valid?
  end
end
