defmodule KarmaWerks.DB.Migrations do
  @moduledoc false

  import ShorterMaps

  @predicates ~S/
    <activity_objects>: [uid] @count @reverse .
    <activity_user>: uid @reverse .
    <activity_verb>: string @index(exact) .
    <comment_date>: datetime @index(day) .
    <comment_text>: string .
    <comment_user>: uid @reverse .
    <group_members>: [uid] @count @reverse .
    <group_name>: string @index(exact) .
    <state_group>: uid @reverse .
    <state_name>: string @index(exact) .
    <state_value>: int @index(int) .
    <tag_name>: string @index(exact) .
    <task_activities>: [uid] @count @reverse .
    <task_ancestors>: [uid] @count @reverse .
    <task_asignees>: [uid] @count @reverse .
    <task_blockers>: [uid] @count @reverse .
    <task_comments>: [uid] @count @reverse .
    <task_description>: string @index(exact, fulltext, trigram) .
    <task_group>: uid @reverse .
    <task_owner>: uid @reverse .
    <task_state>: int @index(int) .
    <task_tags>: [uid] @count @reverse .
    <task_title>: string @index(exact, fulltext, trigram) .
    <user_bio>: string @index(exact, fulltext, trigram) .
    <user_email>: string @index(exact, fulltext, trigram) .
    <user_name>: string @index(exact, fulltext, trigram) .
    <user_password>: password .
    <user_phone>: string @index(exact, fulltext, trigram) .
  /

  defp create_predicates do
    Dlex.alter(:karma_werks, @predicates)
  end

  @spec run :: {:ok, map} | {:error, Dlex.Error.t | term}
  def run do
    with {:ok, predicates} <- create_predicates() do
      {:ok, ~M{predicates}}
    else
      error -> error
    end
  end
end
