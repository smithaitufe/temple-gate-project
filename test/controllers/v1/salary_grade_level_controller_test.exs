defmodule PortalApi.V1.SalaryGradeLevelControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.SalaryGradeLevel
  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, salary_grade_level_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    salary_grade_level = Repo.insert! %SalaryGradeLevel{}
    conn = get conn, salary_grade_level_path(conn, :show, salary_grade_level)
    assert json_response(conn, 200)["data"] == %{"id" => salary_grade_level.id,
      "description" => salary_grade_level.description,
      "salary_structure_type_id" => salary_grade_level.salary_structure_type_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, salary_grade_level_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, salary_grade_level_path(conn, :create), salary_grade_level: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(SalaryGradeLevel, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, salary_grade_level_path(conn, :create), salary_grade_level: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    salary_grade_level = Repo.insert! %SalaryGradeLevel{}
    conn = put conn, salary_grade_level_path(conn, :update, salary_grade_level), salary_grade_level: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(SalaryGradeLevel, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    salary_grade_level = Repo.insert! %SalaryGradeLevel{}
    conn = put conn, salary_grade_level_path(conn, :update, salary_grade_level), salary_grade_level: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    salary_grade_level = Repo.insert! %SalaryGradeLevel{}
    conn = delete conn, salary_grade_level_path(conn, :delete, salary_grade_level)
    assert response(conn, 204)
    refute Repo.get(SalaryGradeLevel, salary_grade_level.id)
  end
end
