defmodule PortalApi.JobPostingTest do
  use PortalApi.ModelCase

  alias PortalApi.JobPosting

  @valid_attrs %{active: true, closing_date: "2010-04-17", opening_date: "2010-04-17", salary: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = JobPosting.changeset(%JobPosting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = JobPosting.changeset(%JobPosting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
