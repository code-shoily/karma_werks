defmodule KarmaWerksWeb.Controllers.LoginController do
  use KarmaWerksWeb, :controller

  def index(conn, _params) do
    render(conn, "login.html")
  end
end
