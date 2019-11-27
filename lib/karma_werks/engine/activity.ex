defmodule KarmaWerks.Engine.Activity do
  @moduledoc """
  Activity stream oriented functions appear here
  """

  alias KarmaWerks.Engine.Helpers

  def add_activity(actor, verb, objects) do
    Dlex.mutate(:karma_werks, ~s[
      _:a <actor> <#{actor}> .
      _:a <verb> "#{verb}" .
      _:a <objects> <#{objects}> .
    ])
  end

  def get_activities() do
    query = ~s/{
      result (func: has(verb)) {
        uid
        name : verb
        actor {
          uid
          name
        }
        objects {
          uid
          name
        }
      }
    }/ |> String.replace("\n", "")
    case Dlex.query(:karma_werks, query) do
      {:ok, %{"result" => node}} -> node
      _ -> nil
    end
  end
end
