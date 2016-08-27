defmodule PortalApi.V1.LeaveDurationView do
  use PortalApi.Web, :view

  def render("index.json", %{leave_durations: leave_durations}) do
    %{data: render_many(leave_durations, PortalApi.V1.LeaveDurationView, "leave_duration.json")}
  end

  def render("show.json", %{leave_duration: leave_duration}) do
    %{data: render_one(leave_duration, PortalApi.V1.LeaveDurationView, "leave_duration.json")}
  end

  def render("leave_duration.json", %{leave_duration: leave_duration}) do
    %{id: leave_duration.id,
      minimum_grade_level: leave_duration.minimum_grade_level,
      maximum_grade_level: leave_duration.maximum_grade_level,
      duration: leave_duration.duration,
      leave_track_type_id: leave_duration.leave_track_type_id}
  end
end
