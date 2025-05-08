defmodule WeeklyOverview do
  @moduledoc false
  use Ash.Resource, domain: Timed.Tracking, data_layer: Ash.DataLayer.Ets

  alias Timed.Tracking.Report

  ets do
    table :weekly_overview
  end

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_primary_key :id
    attribute :start_date, :date, allow_nil?: false, public?: true
    attribute :end_date, :date, allow_nil?: false, public?: true
  end

  relationships do
    has_many :reports, Report do
      no_attributes? true
      filter expr(date >= parent(start_date) && date <= parent(end_date))
    end

    # has_many :reports, Report do
    #   manual fn records, context ->
    #     {:ok, records}
    #   end
    # end
  end
end
