defmodule PortalApi.V1.ProjectTopicController do
  use PortalApi.Web, :controller

  alias PortalApi.ProjectTopic

  plug :scrub_params, "project_topic" when action in [:create, :update]

  def index(conn, _params) do
    project_topics = Repo.all(ProjectTopic)
    render(conn, "index.json", project_topics: project_topics)
  end

  def create(conn, %{"project_topic" => project_topic_params}) do
    changeset = ProjectTopic.changeset(%ProjectTopic{}, project_topic_params)

    case Repo.insert(changeset) do
      {:ok, project_topic} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_project_topic_path(conn, :show, project_topic))
        |> render("show.json", project_topic: project_topic)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    project_topic = Repo.get!(ProjectTopic, id)
    render(conn, "show.json", project_topic: project_topic)
  end

  def update(conn, %{"id" => id, "project_topic" => project_topic_params}) do
    project_topic = Repo.get!(ProjectTopic, id)
    changeset = ProjectTopic.changeset(project_topic, project_topic_params)

    case Repo.update(changeset) do
      {:ok, project_topic} ->
        render(conn, "show.json", project_topic: project_topic)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project_topic = Repo.get!(ProjectTopic, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(project_topic)

    send_resp(conn, :no_content, "")
  end
end
