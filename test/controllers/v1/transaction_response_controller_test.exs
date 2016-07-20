defmodule PortalApi.V1.TransactionResponseControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.TransactionResponse
  @valid_attrs %{code: "some content", description: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, transaction_response_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    transaction_response = Repo.insert! %TransactionResponse{}
    conn = get conn, transaction_response_path(conn, :show, transaction_response)
    assert json_response(conn, 200)["data"] == %{"id" => transaction_response.id,
      "code" => transaction_response.code,
      "description" => transaction_response.description}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, transaction_response_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, transaction_response_path(conn, :create), transaction_response: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(TransactionResponse, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, transaction_response_path(conn, :create), transaction_response: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    transaction_response = Repo.insert! %TransactionResponse{}
    conn = put conn, transaction_response_path(conn, :update, transaction_response), transaction_response: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(TransactionResponse, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    transaction_response = Repo.insert! %TransactionResponse{}
    conn = put conn, transaction_response_path(conn, :update, transaction_response), transaction_response: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    transaction_response = Repo.insert! %TransactionResponse{}
    conn = delete conn, transaction_response_path(conn, :delete, transaction_response)
    assert response(conn, 204)
    refute Repo.get(TransactionResponse, transaction_response.id)
  end
end
