defmodule KarmaWerksWeb.Live.SigninLive do
  @moduledoc false

  use KarmaWerksWeb, :live_auth_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
