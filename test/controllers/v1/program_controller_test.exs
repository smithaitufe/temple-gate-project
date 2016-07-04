defmodule PortalApi.V1.ProgramControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Program
  @valid_attrs %{description: "some content", duration: 42, name: "some content", text: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, program_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    program = Repo.insert! %Program{}
    conn = get conn, program_path(conn, :show, program)
    assert json_response(conn, 200)["data"] == %{"id" => program.id,
      "name" => program.name,
      "description" => program.description,
      "text" => program.text,
      "duration" => program.duration}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, program_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, program_path(conn, :create), program: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Program, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, program_path(conn, :create), program: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    program = Repo.insert! %Program{}
    conn = put conn, program_path(conn, :update, program), program: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Program, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    program = Repo.insert! %Program{}
    conn = put conn, program_path(conn, :update, program), program: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    program = Repo.insert! %Program{}
    conn = delete conn, program_path(conn, :delete, program)
    assert response(conn, 204)
    refute Repo.get(Program, program.id)
  end
end
