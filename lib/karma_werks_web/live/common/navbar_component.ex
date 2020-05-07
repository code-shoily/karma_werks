defmodule KarmaWerksWeb.Common.NavbarComponent do
  @moduledoc false

  alias KarmaWerks.Accounts

  use KarmaWerksWeb, :live_component

  def update(assigns, socket) do
    user = Accounts.get_user_by_uid(assigns.uid)

    {:ok, assign(socket, user: user)}
  end

  def handle_event("user-update", _, socket) do
    {:noreply, socket}
  end

  def handle_event("user-update-password", _, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <nav class="navbar is-primary">
      <div class="navbar-brand">
        <div class="navbar-item">
          <div class="title is-3 has-text-weight-light has-text-white">
            Karma<span class="has-text-weight-bold">Werks</span>
          </div>
        </div>
        <div class="navbar-burger burger" data-target="nav-menu">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>

      <div id="nav-menu" class="navbar-menu">
        <div class="navbar-end">
          <div class="navbar-item has-dropdown is-hoverable">
            <a class="navbar-item has-text-white navbar-link">
              <%= @user["name"] %>
            </a>
            <div class="navbar-dropdown is-right">
              <a class="navbar-item" href="#" phx-click="user-update" phx-target="<%= @myself %>">
                Update Profile
              </a>
              <a class="navbar-item" href="#" phx-click="user-update-password" phx-target="<%= @myself %>">
                Change Password
              </a>
              <hr class="navbar-divider">
              <a class="navbar-item has-text-danger" href="/sign-out">
                Sign-out
              </a>
            </div>
          </div>
        </div>
      </div>
    </nav>
    """
  end
end
