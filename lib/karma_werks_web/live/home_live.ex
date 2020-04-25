defmodule KarmaWerksWeb.Live.HomeLive do
  use KarmaWerksWeb, :live_view

  def mount(_params, %{"token" => _token}, socket) do
    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    send(self(), :unauthorized)
    {:ok, socket}
  end

  def handle_info(:unauthorized, socket) do
    socket =
      socket
      |> put_flash(:error, "You are not authenticated. Please sign in.")
      |> push_redirect(to: Routes.live_path(socket, KarmaWerksWeb.Live.SigninLive))

    {:noreply, socket}
  end
end
