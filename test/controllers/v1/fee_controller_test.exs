defmodule PortalApi.V1.FeeControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Fee
  @valid_attrs %{amount: "120.5", code: "some content", description: "some content", is_catchment_area: true}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, fee_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    fee = Repo.insert! %Fee{}
    conn = get conn, fee_path(conn, :show, fee)
    assert json_response(conn, 200)["data"] == %{"id" => fee.id,
      "code" => fee.code,
      "description" => fee.description,
      "amount" => fee.amount,
      "is_catchment_area" => fee.is_catchment_area,
      "program_id" => fee.program_id,
      "level_id" => fee.level_id,
      "service_charge_type_id" => fee.service_charge_type_id,
      "category_id" => fee.category_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, fee_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, fee_path(conn, :create), fee: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Fee, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, fee_path(conn, :create), fee: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    fee = Repo.insert! %Fee{}
    conn = put conn, fee_path(conn, :update, fee), fee: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Fee, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    fee = Repo.insert! %Fee{}
    conn = put conn, fee_path(conn, :update, fee), fee: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    fee = Repo.insert! %Fee{}
    conn = delete conn, fee_path(conn, :delete, fee)
    assert response(conn, 204)
    refute Repo.get(Fee, fee.id)
  end
end
