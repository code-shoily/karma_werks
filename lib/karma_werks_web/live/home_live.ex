defmodule KarmaWerksWeb.HomeLive do
  @moduledoc false

  use KarmaWerksWeb.AuthHandler

  def mount(_params, session, socket) do
    {:ok, authenticate_socket(self(), socket, session)}
  end
end
