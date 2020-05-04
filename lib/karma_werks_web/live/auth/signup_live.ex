defmodule KarmaWerksWeb.Auth.SignupLive do
  @moduledoc false

  use Phoenix.LiveView,
    layout: {KarmaWerksWeb.LayoutView, "auth.html"}

  alias KarmaWerks.Auth
  alias KarmaWerks.Auth.User
  alias KarmaWerksWeb.AuthView
  alias KarmaWerksWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    Phoenix.View.render(AuthView, "signup.html", assigns)
  end

  @impl true
  def mount(_params, _sessions, socket) do
    changeset = User.signup_changeset(%User{})

    socket =
      socket
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    case Auth.signup(params) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Successfully signed up")
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
