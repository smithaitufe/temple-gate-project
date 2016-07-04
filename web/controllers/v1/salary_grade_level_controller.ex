defmodule PortalApi.V1.SalaryGradeLevelController do
  use PortalApi.Web, :controller

  alias PortalApi.SalaryGradeLevel

  plug :scrub_params, "salary_grade_level" when action in [:create, :update]

  def index(conn, _params) do
    salary_grade_levels = Repo.all(SalaryGradeLevel)
    render(conn, "index.json", salary_grade_levels: salary_grade_levels)
  end

  def create(conn, %{"salary_grade_level" => salary_grade_level_params}) do
    changeset = SalaryGradeLevel.changeset(%SalaryGradeLevel{}, salary_grade_level_params)

    case Repo.insert(changeset) do
      {:ok, salary_grade_level} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_salary_grade_level_path(conn, :show, salary_grade_level))
        |> render("show.json", salary_grade_level: salary_grade_level)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    salary_grade_level = Repo.get!(SalaryGradeLevel, id)
    render(conn, "show.json", salary_grade_level: salary_grade_level)
  end

  def update(conn, %{"id" => id, "salary_grade_level" => salary_grade_level_params}) do
    salary_grade_level = Repo.get!(SalaryGradeLevel, id)
    changeset = SalaryGradeLevel.changeset(salary_grade_level, salary_grade_level_params)

    case Repo.update(changeset) do
      {:ok, salary_grade_level} ->
        render(conn, "show.json", salary_grade_level: salary_grade_level)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    salary_grade_level = Repo.get!(SalaryGradeLevel, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(salary_grade_level)

    send_resp(conn, :no_content, "")
  end
end
