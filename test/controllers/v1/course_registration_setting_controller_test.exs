defmodule PortalApi.V1.CourseRegistrationSettingControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.CourseRegistrationSetting
  @valid_attrs %{closing_date: "2010-04-17"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, course_registration_setting_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    course_registration_setting = Repo.insert! %CourseRegistrationSetting{}
    conn = get conn, course_registration_setting_path(conn, :show, course_registration_setting)
    assert json_response(conn, 200)["data"] == %{"id" => course_registration_setting.id,
      "program_id" => course_registration_setting.program_id,
      "academic_session_id" => course_registration_setting.academic_session_id,
      "closing_date" => course_registration_setting.closing_date}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, course_registration_setting_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, course_registration_setting_path(conn, :create), course_registration_setting: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CourseRegistrationSetting, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, course_registration_setting_path(conn, :create), course_registration_setting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    course_registration_setting = Repo.insert! %CourseRegistrationSetting{}
    conn = put conn, course_registration_setting_path(conn, :update, course_registration_setting), course_registration_setting: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CourseRegistrationSetting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    course_registration_setting = Repo.insert! %CourseRegistrationSetting{}
    conn = put conn, course_registration_setting_path(conn, :update, course_registration_setting), course_registration_setting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    course_registration_setting = Repo.insert! %CourseRegistrationSetting{}
    conn = delete conn, course_registration_setting_path(conn, :delete, course_registration_setting)
    assert response(conn, 204)
    refute Repo.get(CourseRegistrationSetting, course_registration_setting.id)
  end
end
