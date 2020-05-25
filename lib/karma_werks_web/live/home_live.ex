defmodule KarmaWerksWeb.HomeLive do
  @moduledoc false

  use KarmaWerksWeb.AuthHandler

  def mount(_params, session, socket) do
    socket = authenticate_socket(self(), socket, session)
    {:ok, socket}
  end


end
