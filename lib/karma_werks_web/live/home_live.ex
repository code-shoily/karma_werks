defmodule KarmaWerksWeb.HomeLive do
  use KarmaWerksWeb, :live_view

  def mount(_params, %{"token" => nil}, socket) do
    send(self(), :unauthorized)
    {:ok, socket}
  end

  def mount(_params, %{"token" => token}, socket) do
    case KarmaWerks.Cache.get(token) do
      nil ->
        send(self(), :unauthorized)
        {:ok, socket}
      uid -> {:ok, assign(socket, uid: uid)}
    end
  end

  def mount(_params, _session, socket) do
    send(self(), :unauthorized)
    {:ok, socket}
  end

  def handle_info(:unauthorized, socket) do
    socket =
      socket
      |> put_flash(:error, "You are not authenticated. Please sign in.")
      |> push_redirect(to: Routes.live_path(socket, KarmaWerksWeb.Auth.SigninLive))

    {:noreply, socket}
  end
end
