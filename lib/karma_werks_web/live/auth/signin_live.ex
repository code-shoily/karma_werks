defmodule KarmaWerksWeb.Auth.SigninLive do
  @moduledoc false

  use Phoenix.LiveView,
    layout: {KarmaWerksWeb.LayoutView, "auth.html"}

  alias KarmaWerks.Auth.User
  alias KarmaWerksWeb.AuthView

  @impl true
  def render(assigns) do
    Phoenix.View.render(AuthView, "signin.html", assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(changeset: User.signin_changeset(%User{}))
      |> assign(classes: %{email_error: "", password_error: ""})

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", p, socket) do
    IO.inspect(p)
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> User.signin_changeset(params)

    socket =
      socket
      |> assign(changeset: %{changeset | action: :insert})

    {:noreply, socket}
  end
end
