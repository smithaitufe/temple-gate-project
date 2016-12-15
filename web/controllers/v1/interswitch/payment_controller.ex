defmodule PortalApi.V1.Interswitch.PaymentController do
    use PortalApi.Web, :controller
    import SweetXml
    import Ecto.Query
    
    alias PortalApi.{Payment, AcademicSession, Fee, ServiceCharge, ServiceChargeSplit, ProgramApplication}

    def create(conn, _params)  do
        
        {:ok, data, _} = Plug.Conn.read_body(conn)
        IO.inspect data
        

        payment_notification_request = data 
        |> xpath(~x"//PaymentNotificationRequest/Payments/Payment",
            payment_log_id: ~x"./PaymentLogId/text()"s,
            cust_reference: ~x"./CustReference/text()"s,
            payment_reference: ~x"./PaymentReference/text()"s,
            amount: ~x"./Amount/text()"s,
            receipt_no: ~x"./ReceiptNo/text()"s,
            payment_date: ~x"./PaymentDate/text()"s,
            settlement_date: ~x"./SettlementDate/text()"s,
            payment_status: ~x"./PaymentStatus/text()"s,
            payment_item: [ ~x"./PaymentItems/PaymentItem",
                        item_code: ~x"./ItemCode/text()"s,
                        item_amount: ~x"./ItemAmount/text()"s
                    ]        
        )

        %{
            cust_reference: cust_reference, 
            amount: amount, 
            payment_reference: payment_reference, 
            payment_date: payment_date,
            settlement_date: settlement_date,
            receipt_no: receipt_no,
            payment_item: %{ 
                item_code: item_code,
                item_amount: item_amount
            }, 
            payment_status: payment_status
            } = payment_notification_request       

        application = ProgramApplication
        |> where([program_application], program_application.registration_no == ^cust_reference)
        |> distinct(true)
        |> Repo.one
        |> Repo.preload([:user, :program, :department, :level])

        payment_notification_response = case application do
            nil -> get_payment_notification_response
            application -> 
                %{ user: user, program: program } = application
                academic_session = AcademicSession
                |> Ecto.Query.where([academic_session], academic_session.active == true)
                |> Ecto.Query.order_by([academic_session], [desc: academic_session.id])
                |> Ecto.Query.limit(1)
                |> Repo.one
                
                fee = Repo.get_by(Fee, [code: item_code])
                payment = Payment 
                |> join(:inner, [payment], fee in assoc(payment, :fee))
                |> where([payment, fee], payment.academic_session_id == ^academic_session.id and payment.user_id == ^user.id and fee.payer_category_id == ^fee.payer_category_id)
                |> limit(1)
                |> Repo.one

                service_charge_amount = case payment do
                    nil -> 
                        service_charge = Repo.get_by(ServiceCharge, [program_id: application.program_id, payer_category_id: fee.payer_category.id])
                        |> Repo.preload([:service_charge_splits])
                        Enum.reduce(service_charge.service_charge_splits, 0.0,  fn (service_charge_split, acc) -> service_charge_split.amount + acc end)
                    payment -> 300
                end                        
                
                
                payment_params = %{
                    amount: amount,
                    payment_reference_no: payment_reference,
                    payment_date: payment_date,
                    settlement_date: settlement_date,
                    online: false,
                    successful: true,
                    user_id: user.id,
                    response_code: "00",
                    response_description: "Approved Successful",
                    fee_id: fee.id,
                    academic_session_id: academic_session.id,
                    service_charge: service_charge_amount,
                    receipt_no: receipt_no                    
                }

                case Payment.changeset(%Payment{}, payment_params) |> Repo.insert do
                    {:ok, payment} -> get_payment_notification_response(payment.transaction_reference_no, 0)
                    _ -> get_payment_notification_response
                end

        end
        conn
        |> put_resp_header("content-type", "application/xml") 
        |> send_resp(200, payment_notification_response)
    end

    defp get_payment_notification_response(transaction_reference_no \\ nil, status \\ 1) do
        """
            <PaymentNotificationResponse>
                <Payments>
                    <Payment>
                        <PaymentLogId>#{transaction_reference_no}</PaymentLogId>
                        <Status>#{status}</Status>
                    </Payment>
                </Payments>
            </PaymentNotificationResponse>
        """
    end
end