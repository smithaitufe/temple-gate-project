defmodule PortalApi.StudentProjectSupervisorTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentProjectSupervisor

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentProjectSupervisor.changeset(%StudentProjectSupervisor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentProjectSupervisor.changeset(%StudentProjectSupervisor{}, @invalid_attrs)
    refute changeset.valid?
  end
end
