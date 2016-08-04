defmodule PortalApi.V1.GradeView do
  use PortalApi.Web, :view

  def render("index.json", %{grades: grades}) do
    render_many(grades, PortalApi.V1.GradeView, "grade.json")
  end

  def render("show.json", %{grade: grade}) do
    render_one(grade, PortalApi.V1.GradeView, "grade.json")
  end

  def render("grade.json", %{grade: grade}) do
    %{
      id: grade.id,
      minimum: grade.minimum,
      maximum: grade.maximum,
      point: grade.point,
      description: grade.description
    }
  end
end
