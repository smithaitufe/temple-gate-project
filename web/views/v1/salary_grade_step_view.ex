defmodule PortalApi.V1.SalaryGradeStepView do
  use PortalApi.Web, :view
  alias PortalApi.V1.SalaryGradeStepView

  def render("index.json", %{salary_grade_steps: salary_grade_steps}) do
    %{data: render_many(salary_grade_steps, SalaryGradeStepView, "salary_grade_step.json")}
  end

  def render("show.json", %{salary_grade_step: salary_grade_step}) do
    %{data: render_one(salary_grade_step, SalaryGradeStepView, "salary_grade_step.json")}
  end

  def render("salary_grade_step.json", %{salary_grade_step: salary_grade_step}) do
    %{
      id: salary_grade_step.id,
      description: salary_grade_step.description,
      salary_grade_level_id: salary_grade_step.salary_grade_level_id
    }
  end
end
