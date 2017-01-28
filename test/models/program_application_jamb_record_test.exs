defmodule PortalApi.ProgramApplicationJambRecordTest do
  use PortalApi.ModelCase

  alias PortalApi.ProgramApplicationJambRecord

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProgramApplicationJambRecord.changeset(%ProgramApplicationJambRecord{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProgramApplicationJambRecord.changeset(%ProgramApplicationJambRecord{}, @invalid_attrs)
    refute changeset.valid?
  end
end
