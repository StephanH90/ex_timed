defmodule Timed.Projects.Task do
  use Ash.Resource,
    domain: Timed.Projects,
    data_layer: AshPostgres.DataLayer

  alias Timed.Projects.Costcenter
  alias Timed.Projects.Project

  postgres do
    table "projects_task"
    repo Timed.Repo

    # todo: custom indices
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string, constraints: [max_length: 255], allow_nil?: false, public?: true
    attribute :reference, :string, constraints: [max_length: 255], allow_nil?: true, public?: true
    attribute :archived, :boolean, allow_nil?: false, default: false, public?: true
    attribute :estimated_time, Timed.Types.Interval, allow_nil?: true, public?: true

    attribute :cost_center_id, :integer, allow_nil?: false, public?: true
    attribute :project_id, :integer, allow_nil?: false, public?: true
  end

  relationships do
    # todo: deletion cascading stuff
    belongs_to :cost_center, Costcenter
    belongs_to :project, Project
  end
end
