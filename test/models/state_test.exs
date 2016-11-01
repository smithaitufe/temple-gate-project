defmodule PortalApi.StateTest do
  use PortalApi.ModelCase

  alias PortalApi.State

  @valid_attrs %{name: "some content", country_id: 2, is_catchment_area: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = State.changeset(%State{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = State.changeset(%State{}, @invalid_attrs)
    refute changeset.valid?
  end
end
