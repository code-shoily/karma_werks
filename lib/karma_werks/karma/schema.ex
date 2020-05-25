defmodule KarmaWerks.Karma.Schema do
  @moduledoc false
  import Ecto.Changeset

  use Ecto.Schema

  embedded_schema do
    field :name, :string
    field :description, :string
    field :color, :string
    field :visibility, :string
    field :type, :string
    field :universe, :string
  end

  @fields ~w/name description color visibility type/a
  def changeset(karma, params \\ %{}) do
    karma
    |> cast(params, @fields)
  end
end
