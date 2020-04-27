defmodule KarmaWerksWeb.Common.NavbarComponent do
  use KarmaWerksWeb, :live_component

  def render(assigns) do
    ~L"""
    <nav class="navbar is-primary">
      <div class="navbar-brand">
        <div class="navbar-item">
          <span class="title is-3 has-text-white">
          <span class="has-text-weight-light">Karma</span><span class="has-text-weight-bold">Werks</span>
          </span>
        </div>
        <div class="navbar-burger burger" data-target="nav-menu">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>

      <div id="nav-menu" class="navbar-menu">
        <div class="navbar-end">
          <div class="navbar-item">
            <div class="field is-grouped">
              <p class="control">
                <a class="button is-danger has-text-weight-bold" href="/sign-out">Logout</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </nav>
    """
  end
end
