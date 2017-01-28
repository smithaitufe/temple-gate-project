defmodule PortalApi.V1.ProgramApplicationJambRecordController do
  use PortalApi.Web, :controller

  alias PortalApi.ProgramApplicationJambRecord

  def index(conn, _params) do
    program_application_jamb_records = Repo.all(ProgramApplicationJambRecord)
    render(conn, "index.json", program_application_jamb_records: program_application_jamb_records)
  end

  def create(conn, %{"program_application_jamb_record" => program_application_jamb_record_params}) do
    changeset = ProgramApplicationJambRecord.changeset(%ProgramApplicationJambRecord{}, program_application_jamb_record_params)

    case Repo.insert(changeset) do
      {:ok, program_application_jamb_record} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_program_application_jamb_record_path(conn, :show, program_application_jamb_record))
        |> render("show.json", program_application_jamb_record: program_application_jamb_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    program_application_jamb_record = Repo.get!(ProgramApplicationJambRecord, id)
    render(conn, "show.json", program_application_jamb_record: program_application_jamb_record)
  end

  def update(conn, %{"id" => id, "program_application_jamb_record" => program_application_jamb_record_params}) do
    program_application_jamb_record = Repo.get!(ProgramApplicationJambRecord, id)
    changeset = ProgramApplicationJambRecord.changeset(program_application_jamb_record, program_application_jamb_record_params)

    case Repo.update(changeset) do
      {:ok, program_application_jamb_record} ->
        render(conn, "show.json", program_application_jamb_record: program_application_jamb_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    program_application_jamb_record = Repo.get!(ProgramApplicationJambRecord, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(program_application_jamb_record)

    send_resp(conn, :no_content, "")
  end
end
