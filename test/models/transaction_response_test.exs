defmodule PortalApi.TransactionResponseTest do
  use PortalApi.ModelCase

  alias PortalApi.TransactionResponse

  @valid_attrs %{code: "some content", description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TransactionResponse.changeset(%TransactionResponse{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TransactionResponse.changeset(%TransactionResponse{}, @invalid_attrs)
    refute changeset.valid?
  end
end
