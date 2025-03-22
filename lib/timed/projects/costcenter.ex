defmodule Timed.Projects.Costcenter do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Projects,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "projects_costcenter"
    repo Timed.Repo

    custom_indexes do
      index [:name] do
        name "projects_costcenter_name_6a787b98_like"
      end
    end

    identity_index_names name_key: "projects_costcenter_name_key"
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :reference, :string do
      public? true
    end
  end

  relationships do
    has_many :tasks, Timed.Projects.Task
  end

  identities do
    identity :name_key, [:name]
  end
end
