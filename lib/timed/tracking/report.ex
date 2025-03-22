defmodule Timed.Tracking.Report do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Tracking,
    data_layer: AshPostgres.DataLayer

  alias Timed.Employment.User
  alias Timed.Projects.Task

  postgres do
    table "tracking_report"
    repo Timed.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*]

    read :newest do
      prepare build(sort: :id)
    end

    update :update do
      accept [:comment, :duration, :not_billable, :review, :task_id]
    end
  end

  attributes do
    integer_primary_key :id

    attribute :comment, :string do
      allow_nil? false
      constraints trim?: true, allow_empty?: false
      public? true
    end

    attribute :duration, Timed.Types.Interval do
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
      public? true
    end

    attribute :verified_by_id, :integer do
      public? true
    end

    attribute :review, :boolean do
      public? true
      allow_nil? false
      default false
    end

    attribute :rejected, :boolean do
      allow_nil? false
      default false
    end

    create_timestamp :added
    update_timestamp :updated
  end

  relationships do
    belongs_to :user, User
    belongs_to :task, Task
  end
end
