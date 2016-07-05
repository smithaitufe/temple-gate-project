defmodule PortalApi.StudentPaymentTest do
  use PortalApi.ModelCase

  alias PortalApi.StudentPayment

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StudentPayment.changeset(%StudentPayment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StudentPayment.changeset(%StudentPayment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
