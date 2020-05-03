defmodule KarmaWerksWeb.Auth.ResetLive do
  @moduledoc false
  alias KarmaWerks.Auth
  alias KarmaWerks.Auth.User

  use Phoenix.LiveView,
    layout: {KarmaWerksWeb.LayoutView, "auth.html"}

  alias KarmaWerksWeb.AuthView
  alias KarmaWerksWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _sessions, socket) do
    {:ok, assign(socket, changeset: User.password_reset_changeset(%User{}))}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(AuthView, "reset.html", assigns)
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    case Auth.reset(params) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Password reset successful, please check your email")
          |> push_redirect(to: Routes.live_path(socket, KarmaWerksWeb.Auth.SigninLive))

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(changeset: %{changeset | action: :insert})

        {:noreply, socket}
    end
  end
end
