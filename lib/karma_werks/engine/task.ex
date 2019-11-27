defmodule KarmaWerks.Engine.Task do
  @moduledoc """
  Service functions for task management
  """
  def create_task(params) do
    :implement_me
  end

  def update_task(uid, params) do
    :implement_me
  end

  def delete_task(uid, params) do
    :implement_me
  end

  def move_task(uid, to_state) do
    :implement_me
  end

  def comment_on_task(uid, comment_params) do
    :implement_me
  end

  def get_tasks(user, group, opts) do
    :implement_me
  end

  def get_graph(uid, opts) do
    :implement_me
  end
end
