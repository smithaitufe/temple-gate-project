defmodule PortalApi.JambRecordTest do
  use PortalApi.ModelCase

  alias PortalApi.JambRecord

  @valid_attrs %{registration_no: "some content", score: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = JambRecord.changeset(%JambRecord{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = JambRecord.changeset(%JambRecord{}, @invalid_attrs)
    refute changeset.valid?
  end
end
