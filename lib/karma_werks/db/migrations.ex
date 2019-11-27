defmodule KarmaWerks.DB.Migrations do
  @moduledoc false

  import ShorterMaps

  @predicates ~S/
    <objects>: [uid] @count @reverse .
    <verb>: string @index(exact) .
    <start_date>: datetime @index(day) .
    <end_date>: datetime @index(day) .
    <date>: datetime @index(day) .
    <comment>: string .
    <owner>: uid @reverse .
    <members>: [uid] @count @reverse .
    <name>: string @index(exact) .
    <activities>: [uid] @count @reverse .
    <ancestors>: [uid] @count @reverse .
    <asignees>: [uid] @count @reverse .
    <blockers>: [uid] @count @reverse .
    <comments>: [uid] @count @reverse .
    <description>: string @index(exact, fulltext, trigram) .
    <group>: uid @reverse .
    <state>: int @index(int) .
    <tags>: [uid] @count @reverse .
    <bio>: string @index(exact, fulltext, trigram) .
    <email>: string @index(exact, fulltext, trigram) .
    <kind>: string @index(exact) .
    <password>: password .
  /

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
