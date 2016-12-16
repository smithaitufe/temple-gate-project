defmodule PortalApi.V1.ServiceChargeControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.ServiceCharge
  @valid_attrs %{active: true, amount: "120.5"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, service_charge_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    service_charge = Repo.insert! %ServiceCharge{}
    conn = get conn, service_charge_path(conn, :show, service_charge)
    assert json_response(conn, 200)["data"] == %{"id" => service_charge.id,
      "amount" => service_charge.amount,
      "active" => service_charge.active,
      "program_id" => service_charge.program_id,
      "payer_category_id" => service_charge.payer_category_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, service_charge_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, service_charge_path(conn, :create), service_charge: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ServiceCharge, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, service_charge_path(conn, :create), service_charge: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    service_charge = Repo.insert! %ServiceCharge{}
    conn = put conn, service_charge_path(conn, :update, service_charge), service_charge: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ServiceCharge, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    service_charge = Repo.insert! %ServiceCharge{}
    conn = put conn, service_charge_path(conn, :update, service_charge), service_charge: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    service_charge = Repo.insert! %ServiceCharge{}
    conn = delete conn, service_charge_path(conn, :delete, service_charge)
    assert response(conn, 204)
    refute Repo.get(ServiceCharge, service_charge.id)
  end
end
