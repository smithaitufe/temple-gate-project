defmodule PortalApi.V1.AnnouncementControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Announcement
  @valid_attrs %{active: true, body: "some content", expires_at: "2010-04-17", lead: "some content", release_at: "2010-04-17", show_as_dialog: false}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, announcement_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    announcement = Repo.insert! %Announcement{}
    conn = get conn, announcement_path(conn, :show, announcement)
    assert json_response(conn, 200)["data"] == %{"id" => announcement.id,
      "lead" => announcement.lead,
      "body" => announcement.body,
      "release_at" => announcement.release_at,
      "active" => announcement.active,
      "duration" => announcement.duration}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, announcement_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, announcement_path(conn, :create), announcement: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Announcement, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, announcement_path(conn, :create), announcement: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    announcement = Repo.insert! %Announcement{}
    conn = put conn, announcement_path(conn, :update, announcement), announcement: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Announcement, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    announcement = Repo.insert! %Announcement{}
    conn = put conn, announcement_path(conn, :update, announcement), announcement: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    announcement = Repo.insert! %Announcement{}
    conn = delete conn, announcement_path(conn, :delete, announcement)
    assert response(conn, 204)
    refute Repo.get(Announcement, announcement.id)
  end
end
