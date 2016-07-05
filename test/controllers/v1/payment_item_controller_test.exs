defmodule PortalApi.V1.PaymentItemControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.PaymentItem
  @valid_attrs %{amount: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, payment_item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    payment_item = Repo.insert! %PaymentItem{}
    conn = get conn, payment_item_path(conn, :show, payment_item)
    assert json_response(conn, 200)["data"] == %{"id" => payment_item.id,
      "payment_id" => payment_item.payment_id,
      "fee_id" => payment_item.fee_id,
      "amount" => payment_item.amount}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, payment_item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, payment_item_path(conn, :create), payment_item: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(PaymentItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, payment_item_path(conn, :create), payment_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    payment_item = Repo.insert! %PaymentItem{}
    conn = put conn, payment_item_path(conn, :update, payment_item), payment_item: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PaymentItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    payment_item = Repo.insert! %PaymentItem{}
    conn = put conn, payment_item_path(conn, :update, payment_item), payment_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    payment_item = Repo.insert! %PaymentItem{}
    conn = delete conn, payment_item_path(conn, :delete, payment_item)
    assert response(conn, 204)
    refute Repo.get(PaymentItem, payment_item.id)
  end
end
