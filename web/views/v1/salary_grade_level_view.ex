defmodule PortalApi.V1.SalaryGradeLevelView do
  use PortalApi.Web, :view
  alias PortalApi.V1.SalaryGradeLevelView

  def render("index.json", %{salary_grade_levels: salary_grade_levels}) do
    %{data: render_many(salary_grade_levels, SalaryGradeLevelView, "salary_grade_level.json")}
  end

  def render("show.json", %{salary_grade_level: salary_grade_level}) do
    %{data: render_one(salary_grade_level, SalaryGradeLevelView, "salary_grade_level.json")}
  end

  def render("salary_grade_level.json", %{salary_grade_level: salary_grade_level}) do
    %{id: salary_grade_level.id,
      description: salary_grade_level.description,
      salary_structure_type_id: salary_grade_level.salary_structure_type_id}
  end
end
