defmodule Timed.Projects.Task do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Projects,
    data_layer: AshPostgres.DataLayer

  alias Timed.Projects.Costcenter
  alias Timed.Projects.Project

  postgres do
    table "projects_task"
    repo Timed.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    read :for_project do
      argument :project_id, :integer, allow_nil?: false

      filter expr(project_id == ^arg(:project_id))

      prepare {Timed.Preparations.Alphabetically, attribute: :name}
    end

    read :search_for_project do
      argument :project_id, :integer, allow_nil?: false
      argument :search, :string, allow_nil?: false

      prepare Timed.Preparations.Search
      prepare {Timed.Preparations.Alphabetically, attribute: :name}

      filter expr(project_id == ^arg(:project_id))
    end
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
    belongs_to :cost_center, Costcenter, allow_nil?: false, attribute_type: :integer
    belongs_to :project, Project, allow_nil?: false, attribute_type: :integer
  end
end
