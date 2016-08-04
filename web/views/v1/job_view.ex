defmodule PortalApi.V1.JobView do
  use PortalApi.Web, :view

  def render("index.json", %{jobs: jobs}) do
    render_many(jobs, PortalApi.V1.JobView, "job.json")
  end

  def render("show.json", %{job: job}) do
    render_one(job, PortalApi.V1.JobView, "job.json")
  end

  def render("job.json", %{job: job}) do
    %{
      id: job.id,
      title: job.title,
      description: job.description,
      qualifications: job.qualifications,
      responsibilities: job.responsibilities,
      department_type_id: job.department_type_id,
      open: job.open
    }
  end
end
