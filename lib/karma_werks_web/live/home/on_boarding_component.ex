defmodule KarmaWerksWeb.Home.OnBoardingComponent do
  @moduledoc false

  alias KarmaWerks.Accounts
  alias KarmaWerks.Accounts.Schema.Profile
  alias KarmaWerks.Universe.Schema, as: Universe
  alias KarmaWerks.Karma.Schema, as: Karma

  use KarmaWerksWeb, :live_component

  def mount(socket) do
    your_changeset = Profile.changeset(%Profile{})
    universe_changeset = Universe.changeset(%Universe{})
    karma_changeset = Karma.changeset(%Karma{})

    {:ok, assign(socket,
      your_changeset: your_changeset,
      universe_changeset: universe_changeset,
      karma_changeset: karma_changeset)}
  end

  def update(assigns, socket) do
    user = Accounts.get_user_by_uid(assigns.uid)

    {:ok, assign(socket, user: user, current: 0)}
  end

  def render(assigns) do
    ~L"""
    <div class="box">
      <div class="steps">
        <%= steps(@current) %>
        <div class="steps-content">
          <%= your_form(@current == 0, @your_changeset, @myself) %>
          <%= universe_form(@current == 1, @universe_changeset) %>
          <%= karma_form(@current == 2, @karma_changeset) %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("save_profile", %{"profile" => params}, socket) do
    your_changeset = Profile.changeset(%Profile{}, params)
    IO.inspect(params)
    {:noreply, assign(socket, your_changeset: %{your_changeset | action: :insert})}
  end

  defp steps(position) do
    ~E"""
    <div class="step-item  <%= active_if(position == 0) %> <%= success_if(position == 0) %>">
      <div class="step-marker">1</div>
      <div class="step-details">
        <p class="step-title">You</p>
      </div>
    </div>
    <div class="step-item <%= active_if(position == 1) %> <%= success_if(position == 1) %>">
      <div class="step-marker">2</div>
      <div class="step-details">
        <p class="step-title">Universe</p>
      </div>
    </div>
    <div class="step-item <%= active_if(position == 2) %> <%= success_if(position == 2) %>">
      <div class="step-marker">3</div>
      <div class="step-details">
        <p class="step-title">Karma</p>
      </div>
    </div>
    """
  end

  defp your_form(show?, changeset, myself) do
    ~E"""
    <%= f = form_for changeset,
      "#",
      phx_target: myself,
      novalidate: true,
      phx_submit: "save_profile" %>
      <div class="step-content has-text-centered <%= active_if(show?) %>">
        <div class="columns is-centered">
          <div class="column  is-two-thirds is-centered">
            <%= bulma_form_input(f, :bio, icon: "user") %>
            <%= bulma_form_input(f, :designation, icon: "briefcase") %>
            <%= bulma_form_input(f, :phone, icon: "phone") %>
            <div style="margin-top: 2rem">
              <%= bulma_form_submit "Update Profile",
                class: "button is-primary is-rounded" %>
            </div>
          </div>
        </div>
      </div>
    </form>
    """
  end

  defp universe_form(show?, changeset) do
    ~E"""
    <%= f = form_for changeset,
      "#",
      novalidate: true,
      phx_submit: "save_universe" %>
      <div class="step-content has-text-centered <%= active_if(show?) %>">
        <div class="columns is-centered">
          <div class="column  is-two-thirds is-centered">
            <%= bulma_form_input(f, :bio, icon: "user") %>
            <%= bulma_form_input(f, :designation, icon: "briefcase") %>
            <%= bulma_form_input(f, :phone, icon: "phone") %>
            <div style="margin-top: 2rem">
              <%= bulma_form_submit "Update Profile", class: "button is-primary is-rounded" %>
            </div>
          </div>
        </div>
      </div>
    </form>
    """
  end

  defp karma_form(show?, changeset) do
    ~E"""
    <%= f = form_for changeset,
      "#",
      novalidate: true,
      phx_submit: "save_karma" %>
      <div class="step-content has-text-centered <%= active_if(show?) %>">
        <div class="columns is-centered">
          <div class="column  is-two-thirds is-centered">
            <%= bulma_form_input(f, :universe, icon: "user") %>
            <%= bulma_form_input(f, :name, icon: "user") %>
            <%= bulma_form_input(f, :description, icon: "briefcase") %>
            <%= bulma_form_input(f, :color, icon: "briefcase") %>
            <%= bulma_form_input(f, :visibility, icon: "briefcase") %>
            <%= bulma_form_input(f, :type, icon: "phone") %>
            <div style="margin-top: 2rem">
              <%= bulma_form_submit "Save Karma", class: "button is-primary is-rounded" %>
            </div>
          </div>
        </div>
      </div>
    </form>
    """
  end

  defp active_if(condition) do
    (condition && "is-active" || "")
  end

  defp success_if(condition) do
    condition && "is-success" || ""
  end
end
