defmodule KarmaWerksWeb.SessionController do
  alias KarmaWerks.Cache, as: TokenCache
  alias KarmaWerksWeb.Auth.SigninLive
  alias KarmaWerksWeb.Endpoint
  alias KarmaWerksWeb.HomeLive
  alias KarmaWerksWeb.Router.Helpers, as: Routes

  alias Phoenix.Token

  use KarmaWerksWeb, :controller

  @typep maybe_token :: binary() | nil

  def create(conn, %{"user" => %{"token" => token}}) do
    home = Routes.live_path(Endpoint, HomeLive)

    redirect(put_session(conn, "token", new_token(token)), to: home)
  end

  def destroy(conn, _params) do
    signin = Routes.live_path(Endpoint, SigninLive)
    redirect(clear_session(conn), to: signin)
  end

  @spec new_token(maybe_token) :: maybe_token
  defp new_token(token) do
    case Token.verify(KarmaWerksWeb.Endpoint, "auth uid", token, max_age: 10) do
      {:ok, value} ->
        KarmaWerksWeb.Endpoint
        |> Token.sign("auth uid", value)
        |> TokenCache.set(value, return: :key)
      _ -> nil
    end
  end
end
