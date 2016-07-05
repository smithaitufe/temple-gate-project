defmodule PortalApi.V1.StudentResultController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentResult

  plug :scrub_params, "student_result" when action in [:create, :update]

  def index(conn, _params) do
    student_results = Repo.all(StudentResult)
    render(conn, "index.json", student_results: student_results)
  end

  def create(conn, %{"student_result" => student_result_params}) do
    changeset = StudentResult.changeset(%StudentResult{}, student_result_params)

    case Repo.insert(changeset) do
      {:ok, student_result} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_result_path(conn, :show, student_result))
        |> render("show.json", student_result: student_result)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_result = Repo.get!(StudentResult, id)
    render(conn, "show.json", student_result: student_result)
  end

  def update(conn, %{"id" => id, "student_result" => student_result_params}) do
    student_result = Repo.get!(StudentResult, id)
    changeset = StudentResult.changeset(student_result, student_result_params)

    case Repo.update(changeset) do
      {:ok, student_result} ->
        render(conn, "show.json", student_result: student_result)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_result = Repo.get!(StudentResult, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_result)

    send_resp(conn, :no_content, "")
  end
end
