defmodule PortalApi.JobTitleTest do
  use PortalApi.ModelCase

  alias PortalApi.JobTitle

  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = JobTitle.changeset(%JobTitle{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = JobTitle.changeset(%JobTitle{}, @invalid_attrs)
    refute changeset.valid?
  end
end
