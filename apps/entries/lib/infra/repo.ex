defmodule Entries.Repo do
  alias Entries.Habit
  alias Entries.Entry
  alias Entries.Events.{EventRecorded, HabitNotFound, DuplicateEntry}

  @type interval_type :: :today | :week | :month

  @callback get(%Habit{}, any) :: nil | %Entry{}
  @callback get_by_interval(any, [interval: interval_type])
  @callback apply_event(%Entry{}, %EventRecorded{})
  @callback apply_event(%Entry{}, %HabitNotFound{})
  @callback apply_event(%Entry{}, %DuplicateEntry{})
end
