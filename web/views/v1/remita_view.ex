defmodule PortalApi.V1.RemitaView do
  use PortalApi.Web, :view

  def render("hash.json", %{hash: hash}) do
    %{data: hash}
  end

  def render("transaction_id.json", %{transaction_id: transaction_id}) do
    %{data: transaction_id}
  end
end
