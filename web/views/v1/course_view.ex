defmodule PortalApi.V1.CourseView do
  use PortalApi.Web, :view

  def render("index.json", %{courses: courses}) do
    %{data: render_many(courses, PortalApi.V1.CourseView, "course.json")}
  end

  def render("show.json", %{course: course}) do
    %{data: render_one(course, PortalApi.V1.CourseView, "course.json")}
  end

  def render("course.json", %{course: course}) do
    %{id: course.id,
      department_id: course.department_id,
      level_id: course.level_id,
      semester_id: course.semester_id,
      code: course.code,
      title: course.title,
      units: course.units,
      hours: course.hours,
      core: course.core,
      description: course.description
    }
    |> render_department(%{department: course.department})
    |> render_level(%{level: course.level})
    |> render_semester(%{semester: course.semester})
  end

  def render_department(json, %{department: department}) when is_map(department) do
    Map.put(json, :department, render_one(department, PortalApi.V1.DepartmentView, "department.json"))
  end
  def render_department(json, _) do
    json
  end
  def render_level(json, %{level: level}) when is_map(level) do
    Map.put(json, :level, render_one(level, PortalApi.V1.LevelView, "level.json"))
  end
  def render_level(json, _) do
    json
  end
  def render_semester(json, %{semester: semester}) when is_map(semester) do
    Map.put(json, :semester, render_one(semester, PortalApi.V1.TermView, "term.json"))
  end
  def render_semester(json, _) do
    json
  end

  
end
