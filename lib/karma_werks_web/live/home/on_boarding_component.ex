defmodule KarmaWerksWeb.Home.OnBoardingComponent do
  @moduledoc false

  alias KarmaWerks.Accounts

  use KarmaWerksWeb, :live_component

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
          <%= profile_form(@current == 0) %>
          <%= world_form(@current == 1) %>
          <%= karma_form(@current == 2) %>
        </div>
        <div class="steps-actions">
          <div class="steps-action">
            <a href="#" data-nav="next" class="button is-primary is-rounded">
              <%= if @current == 0 do %>
                Let's create a world
              <% end %>
              <%= if @current == 1 do %>
                Let's create some karmas
              <% end %>
              <%= if @current == 2 do %>
                All set!
              <% end %>
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp steps(position) do
    ~E"""
    <div class="step-item  <%= active_if(position == 0) %> <%= success_if(position == 0) %>">
      <div class="step-marker">1</div>
      <div class="step-details">
        <p class="step-title">Profile</p>
      </div>
    </div>
    <div class="step-item <%= active_if(position == 1) %> <%= success_if(position == 1) %>">
      <div class="step-marker">2</div>
      <div class="step-details">
        <p class="step-title">Worlds</p>
      </div>
    </div>
    <div class="step-item <%= active_if(position == 2) %> <%= success_if(position == 2) %>">
      <div class="step-marker">3</div>
      <div class="step-details">
        <p class="step-title">Karmas</p>
      </div>
    </div>
    """
  end

  defp profile_form(show?) do
    ~E"""
      <div class="step-content has-text-centered <%= active_if(show?) %>">
        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label class="label">Username</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control">
                <input class="input" name="username" id="username" type="text" placeholder="Username" autofocus data-validate="require">
              </div>
            </div>
          </div>
        </div>
        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label class="label">Password</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control has-icon has-icon-right">
                <input class="input" type="password" name="password" id="password" placeholder="Password" data-validate="require">
              </div>
            </div>
          </div>
        </div>
        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label class="label">Confirm password</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control has-icon has-icon-right">
                <input class="input" type="password" name="password_confirm" id="password_confirm" placeholder="Confirm password" data-validate="require">
              </div>
            </div>
          </div>
        </div>
      </div>
    """
  end

  defp world_form(show?) do
    ~E"""
    <div class="step-content has-text-centered <%= active_if(show?) %>">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Firstname</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <input class="input" name="firstname" id="firstname" type="text" placeholder="Firstname" autofocus data-validate="require">
            </div>
          </div>
        </div>
      </div>
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Last name</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control has-icon has-icon-right">
              <input class="input" type="text" name="lastname" id="lastname" placeholder="Last name" data-validate="require">
            </div>
          </div>
        </div>
      </div>
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Email</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control has-icon has-icon-right">
              <input class="input" type="email" name="email" id="email" placeholder="Email" data-validate="require">
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp karma_form(show?) do
    ~E"""
    <div class="step-content has-text-centered <%= active_if(show?) %>">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Facebook account</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <input class="input" name="facebook" id="facebook" type="text" placeholder="Facebook account url" autofocus data-validate="require">
            </div>
          </div>
        </div>
      </div>
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">Twitter account</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <input class="input" name="twitter" id="twitter" type="text" placeholder="Twitter account url" autofocus data-validate="require">
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp active_if(condition) do
    (condition && "is-active" || "")
  end

  defp success_if(condition) do
    condition && "is-success" || ""
  end
end
