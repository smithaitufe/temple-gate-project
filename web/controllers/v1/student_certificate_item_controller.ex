defmodule PortalApi.V1.StudentCertificateItemController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentCertificateItem

  plug :scrub_params, "student_certificate_item" when action in [:create, :update]

  def index(conn, _params) do
    student_certificate_items = Repo.all(StudentCertificateItem)
    render(conn, "index.json", student_certificate_items: student_certificate_items)
  end

  def create(conn, %{"student_certificate_item" => student_certificate_item_params}) do
    changeset = StudentCertificateItem.changeset(%StudentCertificateItem{}, student_certificate_item_params)

    case Repo.insert(changeset) do
      {:ok, student_certificate_item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_certificate_item_path(conn, :show, student_certificate_item))
        |> render("show.json", student_certificate_item: student_certificate_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_certificate_item = Repo.get!(StudentCertificateItem, id)
    render(conn, "show.json", student_certificate_item: student_certificate_item)
  end

  def update(conn, %{"id" => id, "student_certificate_item" => student_certificate_item_params}) do
    student_certificate_item = Repo.get!(StudentCertificateItem, id)
    changeset = StudentCertificateItem.changeset(student_certificate_item, student_certificate_item_params)

    case Repo.update(changeset) do
      {:ok, student_certificate_item} ->
        render(conn, "show.json", student_certificate_item: student_certificate_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_certificate_item = Repo.get!(StudentCertificateItem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_certificate_item)

    send_resp(conn, :no_content, "")
  end
end
