defmodule KarmaWerksWeb.HomeController do
  use KarmaWerksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
