defmodule KarmaWerks.Engine.Group do
  @moduledoc """
  Group management services
  """
  def get_user_groups(uid, opts) do
    :not_implemented
  end

  def create_group(params) do
    :not_implemented
  end

  def add_members(uid, members) do
    :implement_me
  end

  def add_member(uid, member) do
    :implement_me
  end

  def get_group_members(uid) do
    :implement_me
  end
end
