defmodule PortalApi.V1.StudentJambRecordController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentJambRecord

  plug :scrub_params, "student_jamb_record" when action in [:create, :update]

  def index(conn, _params) do
    student_jamb_records = Repo.all(StudentJambRecord)
    render(conn, "index.json", student_jamb_records: student_jamb_records)
  end

  def create(conn, %{"student_jamb_record" => student_jamb_record_params}) do
    changeset = StudentJambRecord.changeset(%StudentJambRecord{}, student_jamb_record_params)

    case Repo.insert(changeset) do
      {:ok, student_jamb_record} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_jamb_record_path(conn, :show, student_jamb_record))
        |> render("show.json", student_jamb_record: student_jamb_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_jamb_record = Repo.get!(StudentJambRecord, id)
    render(conn, "show.json", student_jamb_record: student_jamb_record)
  end

  def update(conn, %{"id" => id, "student_jamb_record" => student_jamb_record_params}) do
    student_jamb_record = Repo.get!(StudentJambRecord, id)
    changeset = StudentJambRecord.changeset(student_jamb_record, student_jamb_record_params)

    case Repo.update(changeset) do
      {:ok, student_jamb_record} ->
        render(conn, "show.json", student_jamb_record: student_jamb_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_jamb_record = Repo.get!(StudentJambRecord, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_jamb_record)

    send_resp(conn, :no_content, "")
  end
end
