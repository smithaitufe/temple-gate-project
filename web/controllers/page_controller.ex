defmodule PortalApi.PageController do
  use PortalApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
