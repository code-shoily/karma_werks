defmodule KarmaWerks.DB.Migrations do
  @moduledoc false

  import ShorterMaps

  # Predicate definition should appear here
  # ie. `<comments>: [uid] @count @reverse .`
  @predicates ~S//

  defp create_predicates do
    Dlex.alter(:karma_werks, @predicates)
  end

  @spec run :: {:ok, map} | {:error, Dlex.Error.t | term}
  def run do
    with {:ok, predicates} <- create_predicates() do
      {:ok, ~M{predicates}}
    else
      error -> error
    end
  end
end
