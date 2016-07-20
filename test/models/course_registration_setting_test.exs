defmodule PortalApi.CourseRegistrationSettingTest do
  use PortalApi.ModelCase

  alias PortalApi.CourseRegistrationSetting

  @valid_attrs %{closing_date: "2010-04-17"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CourseRegistrationSetting.changeset(%CourseRegistrationSetting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CourseRegistrationSetting.changeset(%CourseRegistrationSetting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
