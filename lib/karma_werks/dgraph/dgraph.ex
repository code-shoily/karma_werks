defmodule KarmaWerks.Dgraph do
  @moduledoc false

  @db_process KarmaWerks.DgraphProcess

  @spec alter(iodata | map, Keyword.t()) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def alter(statement, opts \\ []), do: Dlex.alter(@db_process, statement, opts)

  @spec alter!(iodata | map, Keyword.t()) :: map
  def alter!(statement, opts \\ []), do: Dlex.alter!(@db_process, statement, opts)

  @spec set(iodata | map, Keyword.t()) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def set(statement, opts \\ []), do: Dlex.set(@db_process, statement, opts)

  @spec set!(iodata | map, Keyword.t()) :: map
  def set!(statement, opts \\ []), do: Dlex.set!(@db_process, statement, opts)

  @spec mutate(Dlex.queries(), iodata | map, Keyword.t()) ::
          {:ok, map} | {:error, Dlex.Error.t() | term}

  def mutate(queries, statement, opts), do: Dlex.mutate(@db_process, queries, statement, opts)

  def mutate(statement), do: mutate(%{}, statement, [])

  def mutate(statement, opts) when is_list(opts), do: mutate(%{}, statement, opts)

  @spec mutate!(Dlex.queries(), iodata, Keyword.t()) :: map | no_return
  def mutate!(queries, statement, opts), do: Dlex.mutate!(@db_process, queries, statement, opts)

  @spec mutate!(iodata | map, Keyword.t()) :: map | no_return
  def mutate!(statement, opts), do: Dlex.mutate!(@db_process, statement, opts)

  def mutate!(statement), do: Dlex.mutate!(@db_process, statement)

  @spec delete(iodata | map, Keyword.t()) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def delete(query, statement, opts), do: Dlex.delete(@db_process, query, statement, opts)

  def delete(statement), do: delete("", statement, [])

  def delete(query, statement) when not is_list(statement),
    do: delete(query, statement, [])

  def delete(statement, opts) when is_list(opts),
    do: delete("", statement, opts)

  @spec delete!(iodata, iodata | map, Keyword.t()) :: map | no_return
  def delete!(query, statement, opts), do: Dlex.delete!(@db_process, query, statement, opts)

  def delete!(query_or_statement, statement_or_opts),
    do: Dlex.delete!(@db_process, query_or_statement, statement_or_opts)

  def delete!(statement), do: Dlex.delete!(@db_process, statement)

  @spec query(iodata, map, Keyword.t()) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def query(statement, parameters \\ %{}, opts \\ []),
    do: Dlex.query(@db_process, statement, parameters, opts)

  @spec query!(iodata, map, Keyword.t()) :: map | no_return
  def query!(statement, parameters \\ %{}, opts \\ []),
    do: Dlex.query!(@db_process, statement, parameters, opts)

  @spec query_schema() :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def query_schema(), do: query("schema {}")

  @spec query_schema!() :: map | no_return
  def query_schema!(), do: query!("schema {}")

  @spec transaction((DBConnection.t() -> result :: any), Keyword.t()) ::
          {:ok, result :: any} | {:error, any}
  def transaction(fun, opts \\ []), do: Dlex.transaction(@db_process, fun, opts)
end
