defmodule Entries.EntryHandlers do
  alias Entries.Commands.RecordEntry
  alias Entries.Entry
  alias Entries.Habit
  alias Entries.Events.{EntryRecorded, HabitNotFound, DuplicateEntry}\

  @repo Application.get_env(:entries, :repo)

  def handle(%RecordEntry{habit_id: habit_id, note: note, recorded_date: recorded_date}) do
    with %Habit{id: id} <- @repo.get(Habit, habit_id),
    [] <- @repo.get_by_interval(habit_id, interval: :today) do
      recorded_entry = %EntryRecorded{
        habit_id: habit_id,
        type: :completed,
        note: note,
        habit_date: DateTime.utc_now(),
        recorded_date: recorded_date
      }

      recorded_entry = @repo.apply_event(%Entry{}, recorded_entry)
    else
      nil ->
        habit_not_found = %HabitNotFound{
          habit_id: habit_id
        }
        @repo.apply_event(%Entry{}, habit_not_found)
      [%Entry{} = entry] ->
        duplicate_entry = %DuplicateEntry{
          entry_id: entry.id,
          habit_id: habit_id,
        }
        @repo.apply_event(entry, duplicate_entry)
    end
  end
end
