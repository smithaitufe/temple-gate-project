defmodule PortalApi.V1.NewsroomControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Newsroom
  @valid_attrs %{active: true, body: "some content", duration: 42, lead: "some content", release_at: "2010-04-17"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, newsroom_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    newsroom = Repo.insert! %Newsroom{}
    conn = get conn, newsroom_path(conn, :show, newsroom)
    assert json_response(conn, 200)["data"] == %{"id" => newsroom.id,
      "lead" => newsroom.lead,
      "body" => newsroom.body,
      "release_at" => newsroom.release_at,
      "active" => newsroom.active,
      "duration" => newsroom.duration}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, newsroom_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, newsroom_path(conn, :create), newsroom: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Newsroom, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, newsroom_path(conn, :create), newsroom: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    newsroom = Repo.insert! %Newsroom{}
    conn = put conn, newsroom_path(conn, :update, newsroom), newsroom: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Newsroom, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    newsroom = Repo.insert! %Newsroom{}
    conn = put conn, newsroom_path(conn, :update, newsroom), newsroom: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    newsroom = Repo.insert! %Newsroom{}
    conn = delete conn, newsroom_path(conn, :delete, newsroom)
    assert response(conn, 204)
    refute Repo.get(Newsroom, newsroom.id)
  end
end
