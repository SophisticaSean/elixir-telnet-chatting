defmodule Chatting2.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = String.to_integer(System.get_env("PORT") || "4040")

    children = [
      {Task.Supervisor, name: Chatting2.TaskSupervisor},
      # start our chat registry, maybe keys: unique?
      {Registry, name: Registry.Chatters, keys: :duplicate},
      Supervisor.child_spec({Task, fn -> Chatting2.accept(port) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Chatting2.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
