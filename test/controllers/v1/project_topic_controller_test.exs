defmodule PortalApi.V1.ProjectTopicControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.ProjectTopic
  @valid_attrs %{user_id: 4, approved: true, title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_topic_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    project_topic = Repo.insert! %ProjectTopic{}
    conn = get conn, project_topic_path(conn, :show, project_topic)
    assert json_response(conn, 200)["data"] == %{"id" => project_topic.id,
      "title" => project_topic.title,
      "student_id" => project_topic.student_id,
      "approved" => project_topic.approved}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, project_topic_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, project_topic_path(conn, :create), project_topic: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ProjectTopic, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_topic_path(conn, :create), project_topic: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project_topic = Repo.insert! %ProjectTopic{}
    conn = put conn, project_topic_path(conn, :update, project_topic), project_topic: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ProjectTopic, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project_topic = Repo.insert! %ProjectTopic{}
    conn = put conn, project_topic_path(conn, :update, project_topic), project_topic: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    project_topic = Repo.insert! %ProjectTopic{}
    conn = delete conn, project_topic_path(conn, :delete, project_topic)
    assert response(conn, 204)
    refute Repo.get(ProjectTopic, project_topic.id)
  end
end
