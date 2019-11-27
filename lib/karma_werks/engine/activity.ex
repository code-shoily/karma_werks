defmodule KarmaWerks.Engine.Activity do
  @moduledoc """
  Activity stream oriented functions appear here
  """
  def add_activity(actor, verb, objects, opts) do
    :implement_me
  end

  def actor_activities(actor) do
    [:implement_me]
  end

  def object_activities(object) do
    [:implement_me]
  end

  def activities_for(uid) do
    actor_activities(uid) ++ object_activities(uid)
  end
end
