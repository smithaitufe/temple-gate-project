defmodule PortalApi.V1.RemitaController do
  use PortalApi.Web, :controller


  def create(conn, all = %{"type" => type}) do
    case type do
      "hash" ->
        if Map.has_key?(all, "params") do do_hashing(conn, Map.get(all, "params")) end
        send_resp(conn, 400, "Bad post request")

      "transaction_id" -> generate_transaction_id(conn)
      _ -> render(conn, 400, "Bad post request")
    end

  end

  defp do_hashing(conn, params) do
    merchant_id = Map.get(params, "merchantId")
    order_id = Map.get(params, "orderId")
    service_type_id = Map.get(params,"serviceTypeId")
    amount = Map.get(params, "amt")
    response_url = Map.get(params, "responseUrl")
    api_key = Map.get(params, "api_key")


    joined_params = "#{merchant_id}#{service_type_id}#{order_id}#{amount}#{response_url}#{api_key}"

    hash = :crypto.hash(:sha256, joined_params)
    |> Base.encode16
    |> String.downcase

    render(conn, "hash.json", hash: hash)
  end

  defp generate_transaction_id(conn) do
    transaction_id = _generate_transaction_id
    render(conn, "transaction_id.json", transaction_id: transaction_id)
  end

  defp _generate_transaction_id do
    :random.seed(:os.timestamp)
    Stream.repeatedly(fn -> trunc(:random.uniform * 10) end ) |> Enum.take(8) |> Enum.join
  end
end
