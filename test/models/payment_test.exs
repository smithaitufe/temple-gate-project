defmodule PortalApi.PaymentTest do
  use PortalApi.ModelCase

  alias PortalApi.Payment

  @valid_attrs %{service_charge: "120.5", sub_total: "120.5", transaction_no: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Payment.changeset(%Payment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Payment.changeset(%Payment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
