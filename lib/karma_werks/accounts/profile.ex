defmodule KarmaWerks.Accounts.Profile do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :designation, :string
    field :bio, :string
    field :phone, :string
  end

  @fields ~w/designation bio phone/a
  def changeset(profile, params) do
    profile
    |> cast(params, @fields)
  end
end
