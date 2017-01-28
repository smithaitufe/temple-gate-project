defmodule PortalApi.V1.ProgramApplicationJambRecordView do
  use PortalApi.Web, :view

  def render("index.json", %{program_application_jamb_records: program_application_jamb_records}) do
    %{data: render_many(program_application_jamb_records, PortalApi.V1.ProgramApplicationJambRecordView, "program_application_jamb_record.json")}
  end

  def render("show.json", %{program_application_jamb_record: program_application_jamb_record}) do
    %{data: render_one(program_application_jamb_record, PortalApi.V1.ProgramApplicationJambRecordView, "program_application_jamb_record.json")}
  end

  def render("program_application_jamb_record.json", %{program_application_jamb_record: program_application_jamb_record}) do
    %{
      jamb_record_id: program_application_jamb_record.jamb_record_id,
      program_application_id: program_application_jamb_record.program_application_id}
  end
end
