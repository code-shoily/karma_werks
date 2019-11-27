defmodule KarmaWerks.Engine.Task do
  @moduledoc """
  Service functions for task management
  """
  import ShorterMaps

  def create_task(~m/name, description, owner, assignees, group/) do
    Dlex.mutate(:karma_werks, ~s[
      _:t <name> "#{name}" .
      _:t <type> "Task" .
      _:t <description> "#{description}" .
      _:t <owner> <#{owner}> .
      _:t <group> <#{group}> .
      #{Enum.map(assignees, fn assignee ->
        ~s[_:t <asignees> <#{assignee}> .]
      end) |> Enum.join("\n")}
    ])
  end

  def create_child_task(~m/name, description, owner, assignees, parent, group/) do
    Dlex.mutate(:karma_werks, ~s[
      _:t <name> "#{name}" .
      _:t <type> "Task" .
      _:t <description> "#{description}" .
      _:t <owner> <#{owner}> .
      _:t <ancestors> <#{parent}> .
      _:t <group> <#{group}> .
      #{assignees |> Enum.map(fn assignee ->
        ~s[_:t <asignees> <#{assignee}> .]
      end) |> Enum.join("\n")}
    ])
  end

  def add_blockers(uid, blockers) do
    Dlex.mutate(:karma_werks, ~s[
      #{Enum.map(blockers, fn blocker ->
        ~s[<#{uid}> <blockers> <#{blocker}> .]
      end) |> Enum.join("\n")}
    ])
  end

  # def move_task(uid, to_state) do
  #   :implement_me
  # end

  # def comment_on_task(uid, comment_params) do
  #   :implement_me
  # end

  # def get_tasks(user, group, opts) do
  #   :implement_me
  # end

  def get_graph(uid) do
    query = ~s/{
      result (func: uid(#{uid})) @recurse {
        uid
        name
        ancestors
        children : ~ancestors
        asignees
        owner
        description
      }
    }/ |> String.replace("\n", "") |> IO.inspect()

    case Dlex.query(:karma_werks, query) do
      {:ok, %{"result" => node}} -> node
      _ -> nil
    end
  end
end
