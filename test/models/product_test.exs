defmodule PortalApi.ProductTest do
  use PortalApi.ModelCase

  alias PortalApi.Product

  @valid_attrs %{available_at: %{day: 17, month: 4, year: 2010}, description: "some content", is_negotiable: true, long_description: "some content", name: "some content", price: "120.5", quantity: 42, unavailable_at: %{day: 17, month: 4, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
