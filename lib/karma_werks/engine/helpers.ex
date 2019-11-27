defmodule KarmaWerks.Engine.Helpers do
  def format(mutation) do
    mutation
    |> String.replace("\n", "")
    |> IO.inspect(label: "DEBUG")
  end

  def get_ids() do
    query = ~s/{
      result (func: has(type)) {
        uid
        name
        type
      }
    }/ |> format()

    case Dlex.query(:karma_werks, query) do
      {:ok, %{"result" => node}} -> node
      _ -> nil
    end
  end
end
