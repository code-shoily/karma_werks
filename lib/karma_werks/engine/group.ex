defmodule KarmaWerks.Engine.Group do
  alias KarmaWerks.Engine.Auth
  alias KarmaWerks.Engine.Helpers

  @moduledoc """
  Group management services
  """
  def get_user_groups(uid) do
    case Auth.get_user_by_uid(uid) do
      %{"groups" => groups} -> groups
      _ -> []
    end
  end

  def create_group(%{"name" => _} = params) do
    Dlex.mutate(:karma_werks, params |> Map.merge(%{"type" => "Group"}))
  end

  def create_group(_), do: :error

  def add_member(group_uid, member_uid) do
    case Auth.get_user_by_uid(member_uid) do
      nil -> :error
      _ -> Dlex.mutate(:karma_werks, ~s[
        <#{group_uid}> <members> <#{member_uid}> .
      ] |> Helpers.format())
    end
  end

  def remove_member(group_uid, member_uid) do
    case Auth.get_user_by_uid(member_uid) do
      nil -> :error
      _ -> Dlex.delete(:karma_werks, ~s[
        <#{group_uid}> <members> <#{member_uid}> * .
      ] |> Helpers.format())
    end
  end

  def get_group(uid) do
    query = ~s/{
      result (func: uid(#{uid})) {
        uid
        name
        members {
          uid
          email
          name
        }
      }
    }/ |> String.replace("\n", "")

    case Dlex.query(:karma_werks, query) do
      {:ok, %{"result" => [node]}} when map_size(node) > 1 -> node
      _ -> nil
    end
  end
end
