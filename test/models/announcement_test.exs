defmodule PortalApi.AnnouncementTest do
  use PortalApi.ModelCase

  alias PortalApi.Announcement

  @valid_attrs %{active: true, body: "some content", expires_at: "2010-04-17", lead: "some content", release_at: "2010-04-17", show_as_dialog: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Announcement.changeset(%Announcement{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Announcement.changeset(%Announcement{}, @invalid_attrs)
    refute changeset.valid?
  end
end
