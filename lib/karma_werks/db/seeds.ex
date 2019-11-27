defmodule KarmaWerks.DB.Seeds do
  alias KarmaWerks.DB.Migrations
  alias KarmaWerks.Engine.Auth
  alias KarmaWerks.Engine.Group
  alias KarmaWerks.Engine.Tag
  alias KarmaWerks.Engine.Task
  alias KarmaWerks.Engine.Activity

  def get_id(value) do
    value |> Map.values() |> hd()
  end

  def run do
    {:ok, karma_werks_group} = Group.create_group(%{
      "name" => "KarmaWerks"
    })

    {:ok, mafinarca_group} = Group.create_group(%{
      "name" => "mafinar.ca"
    })

    {:ok, elixirto_group} = Group.create_group(%{
      "name" => "ElixirTO"
    })

    {:ok, mafinar} = Auth.register_user(%{
      "name" => "Mafinar Khan",
      "email" => "mafinar@gmail.com",
      "bio" => "Polyglot Programmer",
      "password" => "123456"
    })

    {:ok, johndoe} = Auth.register_user(%{
      "name" => "John Doe",
      "email" => "johndoe@mafinar.com",
      "bio" => "Who am I?",
      "password" => "123456"
    })

    {:ok, jonsnow} = Auth.register_user(%{
      "name" => "Jon Snow",
      "email" => "jonsnow@mafinar.com",
      "bio" => "I know Nothing",
      "password" => "123456"
    })

    {:ok, ironman} = Auth.register_user(%{
      "name" => "Iron Man",
      "email" => "tonystark@mafinar.com",
      "bio" => "I am Iron Man",
      "password" => "123456"
    })

    {:ok, batman} = Auth.register_user(%{
      "name" => "Batman",
      "email" => "batman@batman.batman",
      "bio" => "I am Batman",
      "password" => "batman"
    })

    {:ok, groot} = Auth.register_user(%{
      "name" => "Groot",
      "email" => "i.am.groot@mafinar.com",
      "bio" => "I am groot",
      "password" => "iamgroot"
    })

    Group.add_member(karma_werks_group |> get_id(), mafinar |> get_id())
    Group.add_member(karma_werks_group |> get_id(), groot |> get_id())
    Group.add_member(karma_werks_group |> get_id(), ironman |> get_id())
    Group.add_member(mafinarca_group |> get_id(), mafinar |> get_id())
    Group.add_member(mafinarca_group |> get_id(), batman |> get_id())
    Group.add_member(mafinarca_group |> get_id(), jonsnow |> get_id())
    Group.add_member(elixirto_group |> get_id(), batman |> get_id())
    Group.add_member(elixirto_group |> get_id(), jonsnow |> get_id())
    Group.add_member(elixirto_group |> get_id(), johndoe |> get_id())

    {:ok, project_kw} = Task.create_task(%{
      "name" => "KarmaWerks",
      "description" => "KarmaWerks: The Project",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "assignees" => []
    })

    {:ok, project_kw_tag} = Task.create_task(%{
      "name" => "KarmaWerks Awesome Tagger",
      "description" => "Tag Intelligence for KarmaWerks",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "assignees" => []
    })

    {:ok, project_elixirto} = Task.create_task(%{
      "name" => "ElixirTO Website",
      "description" => "Finally a website for ElixirTO",
      "owner" => jonsnow |> get_id(),
      "group" => elixirto_group |> get_id(),
      "assignees" => []
    })

    {:ok, project_mafinarsite} = Task.create_task(%{
      "name" => "Portfolio: mafinar.ca",
      "description" => "A Portfolio Site for Mafinar",
      "owner" => johndoe |> get_id(),
      "group" => mafinarca_group |> get_id(),
      "assignees" => []
    })

    {:ok, kw_api} = Task.create_child_task(%{
      "name" => "Build the API",
      "description" => "Build the KarmaWerks API",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "parent" => project_kw |> get_id(),
      "assignees" => [
        groot |> get_id(),
        ironman |> get_id(),
      ]
    })

    {:ok, kw_en} = Task.create_child_task(%{
      "name" => "Build the Engine",
      "description" => "Build the KarmaWerks Engine",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "parent" => project_kw |> get_id(),
      "assignees" => [
        mafinar |> get_id(),
        ironman |> get_id(),
      ]
    })

    {:ok, kw_ui} = Task.create_child_task(%{
      "name" => "Build the UI",
      "description" => "Build the KarmaWerks UI",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "parent" => project_kw |> get_id(),
      "assignees" => [
        groot |> get_id(),
        ironman |> get_id(),
      ]
    })

    {:ok, kw_ui_login} = Task.create_child_task(%{
      "name" => "Make Login Page",
      "description" => "Build the KarmaWerks Login Page",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "parent" => kw_ui |> get_id(),
      "assignees" => [
        groot |> get_id()
      ]
    })

    {:ok, kw_tag_engine} = Task.create_child_task(%{
      "name" => "Build the API",
      "description" => "Make the Tag Engine",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "parent" => kw_en |> get_id(),
      "assignees" => [
        mafinar |> get_id(),
        groot |> get_id(),
        ironman |> get_id(),
      ]
    })

    {:ok, kw_auth_report} = Task.create_child_task(%{
      "name" => "Build the Reporting Tool",
      "description" => "Build the KarmaWerks AUTH Report",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "parent" => kw_ui_login |> get_id(),
      "assignees" => [
        groot |> get_id(),
        ironman |> get_id(),
      ]
    })

    {:ok, kw_tag_report} = Task.create_child_task(%{
      "name" => "Build the API",
      "description" => "Build the KarmaWerks API",
      "owner" => mafinar |> get_id(),
      "group" => karma_werks_group |> get_id(),
      "parent" => kw_tag_engine |> get_id(),
      "assignees" => [
        groot |> get_id(),
        ironman |> get_id(),
      ]
    })

    Task.add_blockers(kw_tag_report |> get_id(), [
      kw_tag_engine |> get_id(),
      kw_auth_report |> get_id(),
    ])

    Task.add_blockers(kw_auth_report |> get_id(), [
      kw_ui_login |> get_id(),
      kw_en |> get_id(),
    ])
  end
end
