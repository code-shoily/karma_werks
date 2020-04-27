defmodule KarmaWerksWeb.Auth.SigninLive do
  @moduledoc false

  use Phoenix.LiveView,
    layout: {KarmaWerksWeb.LayoutView, "auth.html"}

  alias KarmaWerks.Auth
  alias KarmaWerks.Auth.User
  alias KarmaWerksWeb.AuthView

  # alias KarmaWerksWeb.Router.Helpers, as: Routes
  # alias KarmaWerksWeb.HomeLive

  @impl true
  def render(assigns) do
    Phoenix.View.render(AuthView, "signin.html", assigns)
  end

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
    case Auth.signin(User.signin_changeset(%User{}, params)) do
      {:ok, uid} ->
        token =
          KarmaWerksWeb.Endpoint
          |> Phoenix.Token.sign("auth uid", uid)
          |> KarmaWerks.Cache.set(uid, return: :key)

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
