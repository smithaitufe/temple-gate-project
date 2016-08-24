defmodule PortalApi.V1.StudentController do
  use PortalApi.Web, :controller
  alias PortalApi.Student
  alias PortalApi.V1.{StudentView, PaymentView}

  plug :scrub_params, "student" when action in [:create, :update]

  def index(conn, params) do
    students = Student
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(Student.associations)

    render(conn, "index.json", students: students)
  end

  def create(conn, %{"student" => student_params}) do

    %Student{}
    |> Student.changeset(student_params)
    |> PortalApi.Service.Student.generate_registration_no(8)
    |> PortalApi.Service.Student.generate_matriculation_no
    |> Repo.insert()
    |> case do
      {:ok, student} ->
        student = Repo.preload(student, Student.associations)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_path(conn, :show, student))
        |> render("show.json", student: student)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
      end

  end


  def show(conn, %{"id" => id}) do
    student = Student
    |> Repo.get!(id)
    |> Repo.preload(Student.associations)

    render(conn, "show.json", student: student)
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    student = Repo.get!(Student, id)
    changeset = Student.changeset(student, student_params)

    case Repo.update(changeset) do
      {:ok, student} ->
        student = Repo.preload(student, Student.associations)
        render(conn, "show.json", student: student)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student = Repo.get!(Student, id)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student)

    send_resp(conn, :no_content, "")
  end


  defp build_student_query(query, [{"user_id", user_id} | tail]) do
    query
    |> Ecto.Query.where([s], s.user_id == ^user_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"department_id", department_id} | tail]) do
    query
    |> Ecto.Query.where([s], s.department_id == ^department_id)
    |> build_query(tail)
  end
  defp build_query(query, []), do: query





end
