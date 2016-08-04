defmodule PortalApi.JobTest do
  use PortalApi.ModelCase

  alias PortalApi.Job

  @valid_attrs %{description: "some content", qualifications: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Job.changeset(%Job{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end
end
