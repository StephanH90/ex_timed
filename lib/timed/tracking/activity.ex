defmodule Timed.Tracking.Activity do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Tracking,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tracking_activity"
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

    attribute :comment, :string do
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

    attribute :transferred, :boolean do
      allow_nil? false
      public? true
    end

    attribute :from_time, :time do
      allow_nil? false
      public? true
    end

    attribute :to_time, :time do
      public? true
    end

    attribute :not_billable, :boolean do
      allow_nil? false
      public? true
    end

    attribute :review, :boolean do
      allow_nil? false
      public? true
    end
  end
end
