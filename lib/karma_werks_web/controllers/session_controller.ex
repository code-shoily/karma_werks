defmodule KarmaWerksWeb.SessionController do
  alias Phoenix.LiveView
  alias KarmaWerksWeb.HomeLive
  alias KarmaWerksWeb.Auth.SigninLive

  use KarmaWerksWeb, :controller

  def create(conn, %{"user" => %{"token" => token}}) do
    LiveView.Controller.live_render(put_session(conn, "token", token), HomeLive)
  end

  def destroy(conn, _params) do
    LiveView.Controller.live_render(clear_session(conn), SigninLive)
  end
end
