defmodule EntriesHandlersTest do
  use ExUnit.Case
  alias RepoMock
  alias Entries.EntryHandlers
  import Mox
  doctest Entries

  describe "record entry" do
    test "broadcasts habit not found when habit does not exist" do
      RepoMock
      |> expect(:get, fn %Habit{}, _id ->
        nil
      end)
      |> expect(:apply_event, fn %Entry{}, %HabitNotFound{} ->
        nil
      end)

      bad_habit_command = %RecordEntry{habit_id: "bod_id"}
      EntryHandlers.handle(bad_habit_command)
    end
  end
end
