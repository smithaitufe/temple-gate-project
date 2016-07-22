defmodule PortalApi.NewsroomTest do
  use PortalApi.ModelCase

  alias PortalApi.Newsroom

  @valid_attrs %{active: true, body: "some content", duration: 42, lead: "some content", release_at: "2010-04-17"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Newsroom.changeset(%Newsroom{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Newsroom.changeset(%Newsroom{}, @invalid_attrs)
    refute changeset.valid?
  end
end
