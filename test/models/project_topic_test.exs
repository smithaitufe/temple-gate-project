defmodule PortalApi.ProjectTopicTest do
  use PortalApi.ModelCase

  alias PortalApi.ProjectTopic

  @valid_attrs %{approved: true, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProjectTopic.changeset(%ProjectTopic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProjectTopic.changeset(%ProjectTopic{}, @invalid_attrs)
    refute changeset.valid?
  end
end