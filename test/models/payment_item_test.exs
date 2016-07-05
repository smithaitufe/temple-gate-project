defmodule PortalApi.PaymentItemTest do
  use PortalApi.ModelCase

  alias PortalApi.PaymentItem

  @valid_attrs %{amount: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PaymentItem.changeset(%PaymentItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PaymentItem.changeset(%PaymentItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
