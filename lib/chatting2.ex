defmodule Chatting2 do
  require Logger

  @doc """
  Starts accepting connections on the given `port`.
  """
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                      [:binary, packet: :line, active: :once, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  def check_registry do
    Registry.dispatch(Registry.Chatters, "chatter", fn entries ->
      for {pid, _} <- entries, do: IO.inspect(pid)
    end)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} = Task.Supervisor.start_child(Chatting2.TaskSupervisor, fn -> chatter_init(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp chatter_init(socket) do
    # init function so we only register to the registry once
    me = self()
    {:ok, _} = Registry.register(Registry.Chatters, "chatter", me)

    serve(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> broadcast_line()

    receive_broadcast(socket)

    serve(socket)
  end

  defp receive_broadcast(socket) do
    receive do
      {:new_broadcast, line} -> write_line(line, socket)
    after
      100 -> "nothing yet"
    end
  end

  defp broadcast_line(line) do
    me = self()
    unless String.trim(line) == "" do
      Registry.dispatch(Registry.Chatters, "chatter", fn entries ->
        for {pid, _} <- entries do
          if pid == me do
            newline = "you say: #{line}"
            send(pid, {:new_broadcast, newline})
          else
            newline = "#{inspect(me)} says: #{line}"
            send(pid, {:new_broadcast, newline})
          end
        end
      end)
    end
  end

  defp read_line(socket) do
    case :gen_tcp.recv(socket, 0, 100) do
    {:ok, data} -> data
    _ -> ""
    end
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
