defmodule PortalApi.V1.JambRecordView do
  use PortalApi.Web, :view

  def render("index.json", %{jamb_records: jamb_records}) do
    render_many(jamb_records, PortalApi.V1.JambRecordView, "jamb_record.json")
  end

  def render("show.json", %{jamb_record: jamb_record}) do
    render_one(jamb_record, PortalApi.V1.JambRecordView, "jamb_record.json")
  end

  def render("jamb_record.json", %{jamb_record: jamb_record}) do
    %{id: jamb_record.id,
      user_id: jamb_record.user_id,
      score: jamb_record.score,
      registration_no: jamb_record.registration_no}
  end
end
