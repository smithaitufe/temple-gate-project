defmodule PortalApi.FeeTest do
  use PortalApi.ModelCase

  alias PortalApi.Fee

  @valid_attrs %{amount: "120.5", code: "some content", description: "some content", is_catchment_area: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Fee.changeset(%Fee{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Fee.changeset(%Fee{}, @invalid_attrs)
    refute changeset.valid?
  end
end
