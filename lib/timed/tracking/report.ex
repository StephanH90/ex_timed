defmodule Timed.Tracking.Report do
  use Ash.Resource,
    domain: Timed.Tracking,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tracking_reports"
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

    attribute :not_billable, :boolean do
      allow_nil? false
      public? true
    end

    attribute :billed, :boolean do
      allow_nil? false
      public? true
    end

    attribute :date, :date do
      allow_nil? false
      public? true
    end

    attribute :task_id, :integer do
      public? true
    end

    attribute :user_id, :integer do
      allow_nil? false
      public? true
    end

    attribute :verified_by_id, :integer do
      allow_nil? false
      public? true
    end
  end
end
