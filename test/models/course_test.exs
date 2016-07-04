defmodule PortalApi.CourseTest do
  use PortalApi.ModelCase

  alias PortalApi.Course

  @valid_attrs %{code: "some content", core: true, description: "some content", hours: 42, title: "some content", units: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Course.changeset(%Course{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Course.changeset(%Course{}, @invalid_attrs)
    refute changeset.valid?
  end
end
