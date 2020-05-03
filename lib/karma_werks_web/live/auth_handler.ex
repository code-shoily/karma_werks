defmodule KarmaWerksWeb.AuthHandler do
  alias KarmaWerks.Cache, as: TokenCache
  alias KarmaWerksWeb.Router.Helpers, as: Router

  import Phoenix.LiveView

  defmacro __using__(_) do
    quote do
      alias KarmaWerksWeb.Auth

      import KarmaWerksWeb.AuthHandler, only: [authenticate_socket: 3]

      use KarmaWerksWeb, :live_view

      def handle_info(:unauthorized, socket) do
        socket =
          socket
          |> put_flash(:error, "You are not authenticated. Please sign in.")
          |> push_redirect(to: Router.live_path(socket, Auth.SigninLive))

        {:noreply, socket}
      end
    end
  end

  def authenticate_socket(process, socket, session) do
    socket =
      socket
      |> assign(:uid, nil)
      |> (fn socket ->
            case session do
              %{"token" => nil} ->
                socket

              %{"token" => token} ->
                case TokenCache.get(token) do
                  nil -> socket
                  uid -> assign(socket, uid: uid)
                end

              _ ->
                socket
            end
          end).()

    unless socket.assigns.uid, do: send(process, :unauthorized)

    socket
  end
end
