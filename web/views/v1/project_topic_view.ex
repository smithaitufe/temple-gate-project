defmodule PortalApi.V1.ProjectTopicView do
  use PortalApi.Web, :view
  alias PortalApi.V1.ProjectTopicView

  def render("index.json", %{project_topics: project_topics}) do
    render_many(project_topics, ProjectTopicView, "project_topic.json")
  end

  def render("show.json", %{project_topic: project_topic}) do
    render_one(project_topic, ProjectTopicView, "project_topic.json")
  end

  def render("project_topic.json", %{project_topic: project_topic}) do
    %{
      id: project_topic.id,
      title: project_topic.title,
      submitted_by_user_id: project_topic.submitted_by_user_id,
      approved: project_topic.approved
    }
  end
end
