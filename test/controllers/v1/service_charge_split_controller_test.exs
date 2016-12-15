defmodule PortalApi.V1.ServiceChargeSplitControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.ServiceChargeSplit
  @valid_attrs %{account: "some content", amount: "120.5", bank_code: "some content", name: "some content", required: true}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, service_charge_split_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    service_charge_split = Repo.insert! %ServiceChargeSplit{}
    conn = get conn, service_charge_split_path(conn, :show, service_charge_split)
    assert json_response(conn, 200)["data"] == %{"id" => service_charge_split.id,
      "amount" => service_charge_split.amount,
      "name" => service_charge_split.name,
      "bank_code" => service_charge_split.bank_code,
      "account" => service_charge_split.account,
      "required" => service_charge_split.required,
      "service_charge_id" => service_charge_split.service_charge_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, service_charge_split_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, service_charge_split_path(conn, :create), service_charge_split: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ServiceChargeSplit, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, service_charge_split_path(conn, :create), service_charge_split: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    service_charge_split = Repo.insert! %ServiceChargeSplit{}
    conn = put conn, service_charge_split_path(conn, :update, service_charge_split), service_charge_split: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ServiceChargeSplit, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    service_charge_split = Repo.insert! %ServiceChargeSplit{}
    conn = put conn, service_charge_split_path(conn, :update, service_charge_split), service_charge_split: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    service_charge_split = Repo.insert! %ServiceChargeSplit{}
    conn = delete conn, service_charge_split_path(conn, :delete, service_charge_split)
    assert response(conn, 204)
    refute Repo.get(ServiceChargeSplit, service_charge_split.id)
  end
end
