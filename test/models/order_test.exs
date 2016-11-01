defmodule PortalApi.OrderTest do
  use PortalApi.ModelCase

  alias PortalApi.Order

  @valid_attrs %{buyer: true, buying_amount: "120.5", is_invited: true, selling_amount: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, @invalid_attrs)
    refute changeset.valid?
  end
end
