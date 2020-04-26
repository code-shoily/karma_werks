defmodule KarmaWerksWeb.Auth.SigninLive do
  @moduledoc false

  use Phoenix.LiveView,
    layout: {KarmaWerksWeb.LayoutView, "auth.html"}

  alias KarmaWerks.Auth
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
  def handle_event("save", %{"user" => params}, socket) do
    case Auth.signin(User.signin_changeset(%User{}, params)) do
      {:ok, true} ->
        {:noreply, socket |> put_flash(:info, "Login successful")}
      {:error, changeset} ->
        socket =
          socket
          |> assign(changeset: %{changeset | action: :insert})
          |> (fn socket ->
            case changeset.errors[:base] do
              nil -> socket
              _ -> put_flash(socket, :error, "Invalid credentials")
            end
          end).()

        {:noreply, socket}
    end
  end
end
