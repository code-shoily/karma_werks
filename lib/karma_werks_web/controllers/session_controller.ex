defmodule KarmaWerksWeb.SessionController do
  alias KarmaWerksWeb.HomeLive
  alias KarmaWerksWeb.Auth.SigninLive
  alias KarmaWerksWeb.Router.Helpers, as: Routes
  alias KarmaWerksWeb.Endpoint

  use KarmaWerksWeb, :controller

  def create(conn, %{"user" => %{"token" => token}}) do
    home = Routes.live_path(Endpoint, HomeLive)
    redirect(put_session(conn, "token", token), to: home)
  end

  def destroy(conn, _params) do
    signin = Routes.live_path(Endpoint, SigninLive)
    redirect(clear_session(conn), to: signin)
  end
end
