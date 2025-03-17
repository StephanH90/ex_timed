defmodule Timed.Tracking.Attendance do
  use Ash.Resource,
    domain: Timed.Tracking,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tracking_attendance"
    repo Timed.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    attribute :id, :integer do
      primary_key? true
      allow_nil? false
      public? true
    end

    attribute :date, :date do
      allow_nil? false
      public? true
    end

    attribute :from_time, :time do
      allow_nil? false
      public? true
    end

    attribute :to_time, :time do
      allow_nil? false
      public? true
    end

    attribute :user_id, :integer do
      allow_nil? false
      public? true
    end
  end
end
