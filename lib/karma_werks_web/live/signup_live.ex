defmodule KarmaWerksWeb.Live.SignupLive do
  @moduledoc false

  use KarmaWerksWeb, :live_auth_view

  def mount(_params, _sessions, socket) do
    {:ok, socket}
  end
end
