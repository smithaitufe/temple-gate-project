defmodule PortalApi.Service.ProgramApplication do
  import Ecto.Query
  import Ecto.Changeset

  alias PortalApi.{Repo, ProgramApplication, Department, Program, AcademicSession}

  def generate_registration_no(changeset, number_of_characters) do
    case get_change(changeset, :registration_no) do
        nil ->
            academic_session_id = get_field(changeset, :academic_session_id)
            academic_session = AcademicSession
            |> select([ac], ac.description)
            |> Repo.get!(academic_session_id)
            |> String.slice(0..4)

            registration_no = academic_session <> generate_no(number_of_characters)
            case Repo.get_by(ProgramApplication, [registration_no: registration_no]) do
              program_application -> generate_registration_no(changeset, number_of_characters)
              _ -> put_change(changeset, :registration_no, registration_no)
            end            
        _ -> changeset
    end
  end

  def generate_matriculation_no(changeset) do
    case get_change(changeset, :matriculation_no) do
      nil ->
        department_id = get_field(changeset, :department_id)
        program_id = get_field(changeset, :program_id)
        academic_session_id = get_field(changeset, :academic_session_id)

        {:ok, changeset} = (Repo.transaction fn ->
          student_counts = ProgramApplication
          |> select([program_application], count(program_application.id))
          |> where([program_application], program_application.department_id == ^department_id and program_application.program_id == ^program_id)
          |> Repo.one

          department_code = Department
          |> select([d], d.code)
          |> Repo.get!(department_id)

          program_name = Program
          |> select([p], p.name)
          |> Repo.get!(program_id)

          academic_session = PortalApi.AcademicSession
          |> select([a], a.description)
          |> Repo.get(academic_session_id)
          |> String.slice(2,2)

          number = student_counts + 1
          |> Integer.to_string
          |> String.rjust(4, ?0)

          matriculation_no = "#{department_code}/#{program_name}/#{academic_session}/#{number}"

          Student
          |> Repo.get_by(matriculation_no: matriculation_no)
          |> case do
                nil -> put_change(changeset, :matriculation_no, matriculation_no)
                _ -> generate_matriculation_no(changeset)
              end

        end)
        # Return changeset after matriculation no is generated
        changeset

      _ -> changeset
    end


  end

  defp generate_no(number_of_characters) do
    :random.seed(:os.timestamp)
    Stream.repeatedly(fn -> trunc(:random.uniform * 10) end ) |> Enum.take(number_of_characters) |> Enum.join
  end

end