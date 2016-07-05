defmodule PortalApi.V1.ProjectTopicView do
  use PortalApi.Web, :view

  def render("index.json", %{project_topics: project_topics}) do
    %{data: render_many(project_topics, PortalApi.V1.ProjectTopicView, "project_topic.json")}
  end

  def render("show.json", %{project_topic: project_topic}) do
    %{data: render_one(project_topic, PortalApi.V1.ProjectTopicView, "project_topic.json")}
  end

  def render("project_topic.json", %{project_topic: project_topic}) do
    %{id: project_topic.id,
      title: project_topic.title,
      student_id: project_topic.student_id,
      approved: project_topic.approved}
  end
end
