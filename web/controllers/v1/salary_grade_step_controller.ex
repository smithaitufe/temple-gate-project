defmodule PortalApi.V1.SalaryGradeStepController do
  use PortalApi.Web, :controller

  alias PortalApi.SalaryGradeStep

  plug :scrub_params, "salary_grade_step" when action in [:create, :update]

  def index(conn, _params) do
    salary_grade_steps = Repo.all(SalaryGradeStep)
    render(conn, "index.json", salary_grade_steps: salary_grade_steps)
  end

  def create(conn, %{"salary_grade_step" => salary_grade_step_params}) do
    changeset = SalaryGradeStep.changeset(%SalaryGradeStep{}, salary_grade_step_params)

    case Repo.insert(changeset) do
      {:ok, salary_grade_step} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_salary_grade_step_path(conn, :show, salary_grade_step))
        |> render("show.json", salary_grade_step: salary_grade_step)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    salary_grade_step = Repo.get!(SalaryGradeStep, id)
    render(conn, "show.json", salary_grade_step: salary_grade_step)
  end

  def update(conn, %{"id" => id, "salary_grade_step" => salary_grade_step_params}) do
    salary_grade_step = Repo.get!(SalaryGradeStep, id)
    changeset = SalaryGradeStep.changeset(salary_grade_step, salary_grade_step_params)

    case Repo.update(changeset) do
      {:ok, salary_grade_step} ->
        render(conn, "show.json", salary_grade_step: salary_grade_step)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    salary_grade_step = Repo.get!(SalaryGradeStep, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(salary_grade_step)

    send_resp(conn, :no_content, "")
  end
end
