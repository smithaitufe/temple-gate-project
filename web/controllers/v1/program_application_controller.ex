defmodule PortalApi.V1.ProgramApplicationController do
  use PortalApi.Web, :controller

  alias PortalApi.ProgramApplication

  def index(conn, params) do
    program_applications = ProgramApplication
    |> build_query(Map.to_list(params))
    |> Repo.all()
    |> Repo.preload(ProgramApplication.associations)

    render(conn, "index.json", program_applications: program_applications)
  end

  def create(conn, %{"program_application" => program_application_params}) do
    changeset = ProgramApplication.changeset(%ProgramApplication{}, program_application_params)

    case Repo.insert(changeset) do
      {:ok, program_application} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_program_application_path(conn, :show, program_application))
        |> render("show.json", program_application: program_application)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    program_application = Repo.get!(ProgramApplication, id)
    render(conn, "show.json", program_application: program_application)
  end

  def update(conn, %{"id" => id, "program_application" => program_application_params}) do
    program_application = Repo.get!(ProgramApplication, id)
    changeset = ProgramApplication.changeset(program_application, program_application_params)

    case Repo.update(changeset) do
      {:ok, program_application} ->
        render(conn, "show.json", program_application: program_application)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    program_application = Repo.get!(ProgramApplication, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(program_application)

    send_resp(conn, :no_content, "")
  end


  defp build_query(query, []) do
    query
  end
  defp build_query(query, [{"user_id", user_id} | tail ]) do
    query
    |> Ecto.Query.where([program_application], program_application.user_id == ^user_id)
    |> build_query(tail)

  end

end
