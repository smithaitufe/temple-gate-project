defmodule PortalApi.V1.TransactionResponseView do
  use PortalApi.Web, :view

  def render("index.json", %{transaction_responses: transaction_responses}) do
    %{data: render_many(transaction_responses, PortalApi.V1.TransactionResponseView, "transaction_response.json")}
  end

  def render("show.json", %{transaction_response: transaction_response}) do
    %{data: render_one(transaction_response, PortalApi.V1.TransactionResponseView, "transaction_response.json")}
  end

  def render("transaction_response.json", %{transaction_response: transaction_response}) do
    %{id: transaction_response.id,
      code: transaction_response.code,
      description: transaction_response.description}
  end
end
