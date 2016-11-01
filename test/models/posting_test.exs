defmodule PortalApi.PostingTest do
  use PortalApi.ModelCase

  alias PortalApi.Posting

  @valid_attrs %{active: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Posting.changeset(%Posting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Posting.changeset(%Posting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
