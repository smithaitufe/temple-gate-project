defmodule PortalApi.V1.CourseView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{CourseView, TermView, DepartmentView, LevelView}

  def render("index.json", %{courses: courses}) do
    render_many(courses, CourseView, "course.json")
  end
  def render("show.json", %{course: course}) do
    render_one(course, CourseView, "course.json")
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
    |> DepartmentView.render_department(%{department: course.department})
    |> LevelView.render_level(%{level: course.level})
    |> TermView.render_term("semester", %{term: course.semester})
  end

  def render_course(json, %{course: course}) when is_map(course) do
    Map.put(json, :course, render_one(course, CourseView, "course.json"))
  end
  def render_course(json, _) do
    Map.put(json, :course, %{})
  end

end
