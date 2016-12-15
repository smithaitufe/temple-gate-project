defmodule PortalApi.V1.Interswitch.CustomerController do
    use PortalApi.Web, :controller
    alias PortalApi.{ProgramApplication, Fee} 
    import SweetXml
    

    def show(conn, _params) do
        {:ok, data, _} = Plug.Conn.read_body(conn)

        customer_information_request = data 
        |> xpath(~x"//CustomerInformationRequest",
            cust_reference: ~x"./CustReference/text()"s,
            item_code: ~x"./PaymentItemCode/text()"s)
        
        %{cust_reference: cust_reference, item_code: item_code} = customer_information_request

        program_application = ProgramApplication
        |> Ecto.Query.where([program_application], program_application.registration_no == ^cust_reference)
        |> Ecto.Query.limit(1)
        |> Repo.one
        


        
        customer_information_response = case program_application do
            nil -> get_customer_information
            application -> 
                application = application |> Repo.preload([ {:user, [{:profile, [{:local_government_area, [:state]}]}] } ])
                %{user: user} = application
                %{profile: %{local_government_area: %{state: state}}} = user
                case Repo.get_by(Fee, [code: item_code]) do
                    nil -> get_customer_information
                    fee -> 
                        case fee.is_all do
                            false -> 
                                cond do
                                    fee.is_catchment !== state.is_catchment_area -> get_customer_information
                                    fee.is_catchment === state.is_catchment_area -> get_customer_information(cust_reference, user.first_name, 0)
                                end
                            true -> get_customer_information(cust_reference, user.first_name, 0)
                        end
                end
        end 

        conn
        |> put_resp_header("content-type", "application/xml") 
        |> send_resp(200, customer_information_response)

    end

    defp get_customer_information(cust_reference \\ nil, first_name \\ nil, status \\ 1) do
        """
            <CustomerInformationResponse>
                <MerchantReference>#{Application.get_env(:interswitch, PortalApi.Endpoint)[:merchant_reference]}</MerchantReference>
                <Customers>
                    <Customer>
                        <Status>#{status}</Status>
                        <CustReference>#{cust_reference}</CustReference>            
                        <FirstName>#{first_name}</FirstName>                        
                    </Customer>
                </Customers>
            </CustomerInformationResponse>
        """
    end
end