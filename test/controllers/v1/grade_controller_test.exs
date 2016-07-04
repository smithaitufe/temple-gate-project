defmodule PortalApi.V1.GradeControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Grade
  @valid_attrs %{description: "some content", maximum: 42, minimum: 42, point: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, grade_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    grade = Repo.insert! %Grade{}
    conn = get conn, grade_path(conn, :show, grade)
    assert json_response(conn, 200)["data"] == %{"id" => grade.id,
      "minimum" => grade.minimum,
      "maximum" => grade.maximum,
      "point" => grade.point,
      "description" => grade.description}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, grade_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, grade_path(conn, :create), grade: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Grade, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, grade_path(conn, :create), grade: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    grade = Repo.insert! %Grade{}
    conn = put conn, grade_path(conn, :update, grade), grade: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Grade, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    grade = Repo.insert! %Grade{}
    conn = put conn, grade_path(conn, :update, grade), grade: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    grade = Repo.insert! %Grade{}
    conn = delete conn, grade_path(conn, :delete, grade)
    assert response(conn, 204)
    refute Repo.get(Grade, grade.id)
  end
end
