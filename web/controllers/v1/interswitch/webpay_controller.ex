defmodule PortalApi.V1.Interswitch.WebpayController do
    use PortalApi.Web, :controller
    alias PortalApi.{Payment}


    def index(conn, %{"url" => url, "hash" => hash, "product_id" => product_id, "transaction_reference_no" => transaction_reference_no, "amount" => amount}) do
        query = "#{url}?productid=#{product_id}&transactionreference=#{transaction_reference_no}&amount=#{amount}"
        case query_payment(query, [Hash: hash]) do
            {:ok, response} -> 
                cond do
                    response[:ResponseCode] == "00" && response[:ResponseDescription] == "Approved Successful" ->
                        case Repo.get_by(Payment, transaction_reference_no: transaction_reference_no) do
                            payment -> 
                                payment_params = %{Map.from_struct(payment) | successful: true, payment_reference_no: response[:PaymentReference], response_code: response[:ResponseCode], response_description: response[:ResponseDescription]}
                                {:ok, payment} = Payment.changeset(payment, payment_params) |> Repo.update
                                {:ok, payment}
                            nil -> "Yet to be fixed"                                  
                        end
                    true -> send_resp(conn, 404, "")
                    
                end 
        end
    end
    def create(conn, params = %{"txnref" => txn_ref}) do
        case Repo.get_by(Payment, [transaction_reference_no: txn_ref]) do
            nil -> send_resp(conn, 404, "Invalid operation") |> halt()
            payment -> Phoenix.Controller.redirect(conn, external: payment.site_redirect_url) |> halt()
        end
    end
    defp query_payment(url, headers) do        
        opts = [ ssl: [{:versions, [:'tlsv1.2']}] ]
        case HTTPoison.get url, headers, opts do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> 
                map = body
                |> Poison.decode!
                |> Map.take(@expected_fields)
                |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)

                IO.inspect map

                {:ok, map}
            {:error, %HTTPoison.Error{reason: reason}} ->
                {:error, reason}
        end
    end
end