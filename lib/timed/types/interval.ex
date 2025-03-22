defmodule Timed.Types.Interval do
  @moduledoc """
  An Ash type that handles PostgreSQL intervals, primarily used for time durations.

  This type can handle:
  - Integer input (interpreted as minutes)
  - String input (parseable as minutes)
  - Postgrex.Interval structs

  All values are internally stored as PostgreSQL intervals but exposed as minutes in the API.
  """

  use Ash.Type
  alias Postgrex.Interval

  @type minutes :: non_neg_integer()
  @type interval :: Postgrex.Interval.t()

  # Returns the underlying storage type (the underlying type of the ecto type of the ash type)
  @impl Ash.Type
  def storage_type(_), do: :interval

  # Casts input (e.g. unknown) data to an instance of the type, or errors
  # Cast the data into something used at runtime. It's like `cast` in Ecto Types.
  @impl Ash.Type
  @spec cast_input(nil | minutes() | String.t() | interval(), term()) ::
          {:ok, nil | interval()} | {:error, String.t()}

  def cast_input(nil, _), do: {:ok, nil}

  def cast_input(value, _) when is_integer(value) and value >= 0 do
    {:ok, minutes_to_interval(value)}
  end

  def cast_input(%Interval{} = interval, _) do
    {:ok, interval}
  end

  def cast_input(value, _) when is_binary(value) do
    case Timed.DurationFormatter.parse(value) do
      {:ok, minutes} -> {:ok, minutes_to_interval(minutes)}
      {:error, reason} -> {:error, reason}
    end
  end

  def cast_input(_, _) do
    {:error, "Invalid interval: expected either minutes as a number or a PostgreSQL interval"}
  end

  # Casts a value from the data store to an instance of the type, or errors
  # This is like the load in Ecto types.
  @impl Ash.Type
  @spec cast_stored(nil | Postgrex.Interval.t(), term()) ::
          {:ok, nil | integer()} | {:error, String.t()}
  def cast_stored(nil, _), do: {:ok, nil}

  def cast_stored(%Interval{} = interval, _) do
    {:ok, interval_to_minutes(interval)}
  end

  def cast_stored(_, _),
    do: {:error, "Invalid stored value: expected a PostgreSQL interval"}

  # Casts a value from the Elixir type to a value that the data store can persist
  # This is like the dump in Ecto types. We have the value casted used in `cast_input`.
  @impl Ash.Type
  @spec dump_to_native(nil | Postgrex.Interval.t(), term()) ::
          {:ok, nil | Postgrex.Interval.t()} | {:error, String.t()}
  def dump_to_native(nil, _), do: {:ok, nil}

  def dump_to_native(%Interval{} = interval, _), do: {:ok, interval}

  def dump_to_native(_, _),
    do: {:error, "Invalid value: expected a PostgreSQL interval"}

  @doc """
  Converts a duration in minutes to a PostgreSQL interval.

  The conversion is done by:
  1. Converting minutes to total seconds
  2. Extracting complete days from seconds
  3. Converting days to months (using 30-day month approximation)
  4. Calculating remaining days and seconds

  ## Parameters
    * `minutes` - Duration in minutes to convert

  ## Returns
    * `Postgrex.Interval` struct representing the duration
  """
  @spec minutes_to_interval(minutes()) :: interval()
  def minutes_to_interval(minutes) do
    total_seconds = minutes * 60
    days = div(total_seconds, 86_400)
    remaining_seconds = rem(total_seconds, 86_400)

    %Interval{
      # Approximate months as 30-day units
      months: div(days, 30),
      # Remaining days after extracting months
      days: rem(days, 30),
      # Remaining seconds within the day
      secs: remaining_seconds
    }
  end

  @doc """
  Converts a PostgreSQL interval to minutes.

  The conversion assumes 30-day months and:
  1. Converts months to days (months * 30)
  2. Adds explicit days
  3. Converts total days to seconds
  4. Adds explicit seconds
  5. Converts total seconds to minutes

  ## Parameters
    * `interval` - A Postgrex.Interval struct to convert

  ## Returns
    * Number of minutes as an integer
    * `{:error, reason}` if input is not a valid interval
  """
  @spec interval_to_minutes(interval()) :: minutes() | {:error, String.t()}
  def interval_to_minutes(%Postgrex.Interval{months: months, days: days, secs: secs}) do
    # Assuming each month has 30 days
    total_days = months * 30 + days
    total_seconds = total_days * 86_400 + secs
    # Convert seconds to minutes
    div(total_seconds, 60)
  end

  def interval_to_minutes(_), do: {:error, "Invalid input: expected a PostgreSQL interval"}

  defimpl String.Chars, for: [Postgrex.Interval] do
    import Kernel, except: [to_string: 1]

    def to_string(%{months: 0, days: 0, secs: 0}), do: "<None>"

    def to_string(%{months: months, days: days, secs: secs}) do
      parts =
        [
          if(months > 0, do: "#{months} months"),
          if(days > 0, do: "#{days} days"),
          if(secs > 0, do: "#{secs} seconds")
        ]
        |> Enum.reject(&is_nil/1)
        |> Enum.join(" ")

      "Every #{parts}"
    end
  end
end
