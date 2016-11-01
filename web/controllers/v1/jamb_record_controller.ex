defmodule PortalApi.V1.JambRecordController do
  use PortalApi.Web, :controller

  alias PortalApi.JambRecord

  plug :scrub_params, "jamb_record" when action in [:create, :update]

  def index(conn, _params) do
    jamb_records = Repo.all(JambRecord)
    render(conn, "index.json", jamb_records: jamb_records)
  end

  def create(conn, %{"jamb_record" => jamb_record_params}) do
    changeset = JambRecord.changeset(%JambRecord{}, jamb_record_params)

    case Repo.insert(changeset) do
      {:ok, jamb_record} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_jamb_record_path(conn, :show, jamb_record))
        |> render("show.json", jamb_record: jamb_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    jamb_record = Repo.get!(JambRecord, id)
    render(conn, "show.json", jamb_record: jamb_record)
  end

  def update(conn, %{"id" => id, "jamb_record" => jamb_record_params}) do
    jamb_record = Repo.get!(JambRecord, id)
    changeset = JambRecord.changeset(jamb_record, jamb_record_params)

    case Repo.update(changeset) do
      {:ok, jamb_record} ->
        render(conn, "show.json", jamb_record: jamb_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    jamb_record = Repo.get!(JambRecord, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(jamb_record)

    send_resp(conn, :no_content, "")
  end
end
