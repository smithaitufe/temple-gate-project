defmodule PortalApi.Email do
    use Bamboo.Phoenix, view: PortalApi.EmailView

    def welcome_text_email(subject, email_address, body) do
        new_email
        |> to(email_address)
        |> from("info@templegatepolytechnic.edu.ng")
        |> subject(subject)
        |> text_body(body)
    end
    def welcome_html_email(subject, email_address, body) do
        new_email
        |> to(email_address)
        |> from("info@templegatepolytechnic.edu.ng")
        |> subject(subject)
        |> html_body(body)
    end


end