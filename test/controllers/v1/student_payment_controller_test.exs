defmodule PortalApi.V1.StudentPaymentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentPayment
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_payment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_payment = Repo.insert! %StudentPayment{}
    conn = get conn, student_payment_path(conn, :show, student_payment)
    assert json_response(conn, 200)["data"] == %{"id" => student_payment.id,
      "student_id" => student_payment.student_id,
      "payment_id" => student_payment.payment_id,
      "academic_session_id" => student_payment.academic_session_id,
      "level_id" => student_payment.level_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_payment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_payment_path(conn, :create), student_payment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentPayment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_payment_path(conn, :create), student_payment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_payment = Repo.insert! %StudentPayment{}
    conn = put conn, student_payment_path(conn, :update, student_payment), student_payment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentPayment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_payment = Repo.insert! %StudentPayment{}
    conn = put conn, student_payment_path(conn, :update, student_payment), student_payment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_payment = Repo.insert! %StudentPayment{}
    conn = delete conn, student_payment_path(conn, :delete, student_payment)
    assert response(conn, 204)
    refute Repo.get(StudentPayment, student_payment.id)
  end
end
