defmodule Chatting2Test do
  use ExUnit.Case
  doctest Chatting2

  test "greets the world" do
    assert Chatting2.hello() == :world
  end
end
