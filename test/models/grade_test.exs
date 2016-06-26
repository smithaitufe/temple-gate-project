defmodule PortalApi.GradeTest do
  use PortalApi.ModelCase

  alias PortalApi.Grade

  @valid_attrs %{maximum: 42, minimum: 42, point: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Grade.changeset(%Grade{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Grade.changeset(%Grade{}, @invalid_attrs)
    refute changeset.valid?
  end
end
