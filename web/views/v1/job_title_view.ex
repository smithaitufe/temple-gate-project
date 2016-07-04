defmodule PortalApi.V1.JobTitleView do
  use PortalApi.Web, :view

  def render("index.json", %{job_titles: job_titles}) do
    %{data: render_many(job_titles, PortalApi.V1.JobTitleView, "job_title.json")}
  end

  def render("show.json", %{job_title: job_title}) do
    %{data: render_one(job_title, PortalApi.V1.JobTitleView, "job_title.json")}
  end

  def render("job_title.json", %{job_title: job_title}) do
    %{id: job_title.id,
      description: job_title.description,
      department_type_id: job_title.department_type_id}
  end
end
