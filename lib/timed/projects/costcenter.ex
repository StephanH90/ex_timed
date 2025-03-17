defmodule Timed.Projects.Costcenter do
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
    attribute :id, :integer do
      primary_key? true
      allow_nil? false
      public? true
    end

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :reference, :string do
      public? true
    end
  end

  identities do
    identity :name_key, [:name]
  end
end
