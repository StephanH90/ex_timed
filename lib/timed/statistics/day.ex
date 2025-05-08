defmodule Timed.Statistics.Day do
  @moduledoc """
  Represents a combination of day and user. Can be used to load the reports for that user
  on that day or to sum the duration of their reported time.

  These days are NOT persisted to any kind of storage so they can't be read using `Ash.read(Timed.Statistics.Day)`
  as an example. They are purely for doing calculations. However, if we would every decide to cache these calculations
  all it would take is to add a `data_layer: AshPostgres.DataLayer`.
  """
  use Ash.Resource, domain: Timed.Tracking

  alias Timed.Tracking.Report

  actions do
    defaults [:read, :destroy, update: :*]

    create :create do
      accept [:date, :reports, :user_id]
      argument :user, :map, allow_nil?: true

      change manage_relationship(:user, type: :append)
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :date, :date, allow_nil?: false, public?: true

    attribute :reports, {:array, :struct} do
      constraints items: [instance_of: Report]
      allow_nil? false
    end
  end

  relationships do
    belongs_to :user, Timed.Employment.User, allow_nil?: false, attribute_type: :integer
  end

  calculations do
    calculate :duration, :float, SumDuration
  end
end

defmodule SumDuration do
  @moduledoc """
  Sums the duration of all the reports. Automatically loads the :reports calculation
  if it hasn't been loaded yet.
  """
  alias Timed.Tracking.Report
  use Ash.Resource.Calculation
  require Ash.Query

  def load(_, _, _), do: [:reports]

  def calculate(days, _, _) do
    Enum.map(days, fn day ->
      day.reports
      |> Enum.map(& &1.duration)
      |> Enum.sum()
    end)
  end
end
