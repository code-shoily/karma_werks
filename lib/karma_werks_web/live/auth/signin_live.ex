defmodule KarmaWerksWeb.Auth.SigninLive do
  @moduledoc false

  use KarmaWerksWeb, :live_auth_view

  alias KarmaWerks.Cache, as: TokenCache

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(token_changeset: User.token_changeset(%User{}))
      |> assign(has_credential_error: false)
      |> assign(
        changeset: User.signin_changeset(%User{})
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    case Accounts.signin(params) do
      {:ok, uid} ->
        token =
          KarmaWerksWeb.Endpoint
          |> Phoenix.Token.sign("auth uid", uid)
          |> TokenCache.set(uid, return: :key, ttl: 10)

        socket =
          socket
          |> assign(has_credential_error: false)
          |> assign(token_changeset: User.token_changeset(%User{token: token}))

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(changeset: %{changeset | action: :insert})
          |> assign(has_credential_error: (changeset.errors[:base] && true) || false)

        {:noreply, socket}
    end
  end
end
