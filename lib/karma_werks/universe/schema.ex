defmodule KarmaWerks.Universe.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :description, :string
    field :template, :string
    field :is_public, :boolean
  end

  @fields ~w/name description template is_public/a
  def changeset(universe, params \\ %{}) do
    universe
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
