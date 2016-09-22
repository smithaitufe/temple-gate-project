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
    render("course_lite.json", course: course)
    |> Map.put(:department, render_one(course.department, DepartmentView, "department.json"))
    |> Map.put(:level, render_one(course.level, LevelView, "level.json"))
    |> Map.put(:course_category, render_one(course.course_category, TermView, "term.json"))
    |> Map.put(:semester, render_one(course.semester, TermView, "term.json"))
  end


  def render("course_lite.json", %{course: course}) do
    %{id: course.id,
      department_id: course.department_id,
      level_id: course.level_id,
      semester_id: course.semester_id,
      code: course.code,
      title: course.title,
      units: course.units,
      hours: course.hours,
      description: course.description,
      course_category_id: course.course_category_id
    }
  end

end
