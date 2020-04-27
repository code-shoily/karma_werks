defmodule Mix.Tasks.Dgraph.Setup do
  alias KarmaWerks.Dgraph.Types.Factory

  use Mix.Task

  @shortdoc "Creates all Dgraph types"
  def run(_) do
    Mix.Task.run("app.start", [])

    with :ok <- Factory.create() do
      Mix.shell().info("All types have been created")
    else
      error -> Mix.shell().error(to_string(error))
    end
  end
end
