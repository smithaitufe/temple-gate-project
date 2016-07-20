defmodule PortalApi.V1.StudentCertificateSubjectGradeController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentCertificateSubjectGrade

  plug :scrub_params, "student_certificate_subject_grade" when action in [:create, :update]

  def index(conn, _params) do
    student_certificate_subject_grades = Repo.all(StudentCertificateSubjectGrade)
    render(conn, "index.json", student_certificate_subject_grades: student_certificate_subject_grades)
  end

  def create(conn, %{"student_certificate_subject_grade" => student_certificate_subject_grade_params}) do
    changeset = StudentCertificateSubjectGrade.changeset(%StudentCertificateSubjectGrade{}, student_certificate_subject_grade_params)

    case Repo.insert(changeset) do
      {:ok, student_certificate_subject_grade} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_certificate_subject_grade_path(conn, :show, student_certificate_subject_grade))
        |> render("show.json", student_certificate_subject_grade: student_certificate_subject_grade)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_certificate_subject_grade = Repo.get!(StudentCertificateSubjectGrade, id)
    render(conn, "show.json", student_certificate_subject_grade: student_certificate_subject_grade)
  end

  def update(conn, %{"id" => id, "student_certificate_subject_grade" => student_certificate_subject_grade_params}) do
    student_certificate_subject_grade = Repo.get!(StudentCertificateSubjectGrade, id)
    changeset = StudentCertificateSubjectGrade.changeset(student_certificate_subject_grade, student_certificate_subject_grade_params)

    case Repo.update(changeset) do
      {:ok, student_certificate_subject_grade} ->
        render(conn, "show.json", student_certificate_subject_grade: student_certificate_subject_grade)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_certificate_subject_grade = Repo.get!(StudentCertificateSubjectGrade, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_certificate_subject_grade)

    send_resp(conn, :no_content, "")
  end
end
