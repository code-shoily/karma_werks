defmodule Mix.Tasks.Dgraph.Setup do
  @moduledoc """
  Sets up the Dgraph types.
  """

  alias KarmaWerks.Dgraph.Types.Factory

  use Mix.Task

  @shortdoc "Creates all Dgraph types"
  def run(_) do
    Mix.Task.run("app.start", [])

    case Factory.create() do
      :ok -> Mix.shell().info("All types have been created")
      error -> raise error
    end
  end
end
