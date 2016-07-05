defmodule PortalApi.StudentTest do
  use PortalApi.ModelCase

  alias PortalApi.Student

  @valid_attrs %{birth_date: "2010-04-17", email: "some content", first_name: "some content", last_name: "some content", matriculation_no: "some content", middle_name: "some content", phone_number: "some content", registration_no: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Student.changeset(%Student{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Student.changeset(%Student{}, @invalid_attrs)
    refute changeset.valid?
  end
end
