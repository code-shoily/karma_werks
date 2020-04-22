defmodule KarmaWerksWeb.PageLive do
  @moduledoc false

  use KarmaWerksWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{}) |> put_flash(:info, "HELLO WORLD")}
  end
end
