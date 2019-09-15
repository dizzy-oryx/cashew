defmodule EntriesTest do
  use ExUnit.Case
  doctest Entries

  test "greets the world" do
    assert Entries.hello() == :world
  end
end
