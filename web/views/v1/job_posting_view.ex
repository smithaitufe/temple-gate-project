defmodule PortalApi.V1.JobPostingView do
  use PortalApi.Web, :view

  def render("index.json", %{job_postings: job_postings}) do
    render_many(job_postings, PortalApi.V1.JobPostingView, "job_posting.json")
  end

  def render("show.json", %{job_posting: job_posting}) do
    render_one(job_posting, PortalApi.V1.JobPostingView, "job_posting.json")
  end

  def render("job_posting.json", %{job_posting: job_posting}) do
    %{id: job_posting.id,
      opening_date: job_posting.opening_date,
      closing_date: job_posting.closing_date,
      posted_by_user_id: job_posting.posted_by_user_id,
      active: job_posting.active,
      application_method: job_posting.application_method}
  end
end
