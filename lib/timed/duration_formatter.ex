defmodule Timed.DurationFormatter do
  @moduledoc """
  This module provides functions to format and parse durations.
  """

  @doc """
  Formats a duration in minutes to a string in the format "HH:MM". It will also round up the duration to the nearest 15 minutes.
  """
  @spec format(integer | Postgrex.Interval.t()) :: String.t()
  def format(duration) when is_integer(duration) do
    duration = round_up_to_nearest_15!(duration)

    hours = div(duration, 60)
    minutes = rem(duration, 60)
    "#{String.pad_leading("#{hours}", 2, "0")}:#{String.pad_leading("#{minutes}", 2, "0")}"
  end

  def format(%Postgrex.Interval{} = interval) do
    interval
    |> Timed.Types.Interval.interval_to_minutes()
    |> format()
  end

  @spec to_minutes(nil | integer() | Postgrex.Interval.t()) :: integer() | {:error, <<_::360>>}
  def to_minutes(nil), do: 0
  def to_minutes(0), do: 0
  def to_minutes(duration) when is_integer(duration), do: duration

  def to_minutes(%Postgrex.Interval{} = interval),
    do: Timed.Types.Interval.interval_to_minutes(interval)

  @doc """
  Parses a string or integer to duration in minutes and then rounds up to the nearest 15 min interval.
  """
  @spec parse(String.t() | integer()) :: {:ok, integer()} | {:error, String.t()}
  def parse("00:00"), do: {:ok, 0}
  def parse(""), do: {:ok, 0}
  def parse(nil), do: {:ok, 0}

  def parse(duration) when is_integer(duration) do
    # we don't parse integers directly instead we turn them into a string like "03:15" and then parse them to minutes
    duration
    |> round_up_to_nearest_15!()
    |> format()
    |> parse()
  end

  def parse(duration) do
    case String.split(duration, ":") do
      [hours, minutes] ->
        hours_as_integer = String.to_integer(hours)
        minutes_as_integer = minutes |> String.to_integer() |> round_up_to_nearest_15!()

        {:ok, hours_as_integer * 60 + minutes_as_integer}

      [minutes] ->
        {:ok, minutes |> String.to_integer() |> round_up_to_nearest_15!()}
    end
  end

  def parse!(duration) do
    case parse(duration) do
      {:ok, minutes} -> minutes
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  defp round_up_to_nearest_15!(duration) do
    remainder = rem(duration, 15)

    if remainder === 0 do
      # we don't allow negative values
      max(duration, 0)
    else
      max(duration + (15 - remainder), 0)
    end
  end
end
