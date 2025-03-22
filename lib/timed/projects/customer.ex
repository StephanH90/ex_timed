defmodule Timed.Projects.Customer do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Projects,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "projects_customer"
    repo Timed.Repo

    custom_indexes do
      index [:name] do
        name "projects_customer_name_5adc47bc_like"
      end

      index [:reference] do
        name "projects_customer_reference_3d93d989_like"
      end
    end

    identity_index_names name_5adc47bc_uniq: "projects_customer_name_5adc47bc_uniq"
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    read :alphabetically do
      prepare build(sort: :name)
    end

    read :search do
      argument :search, :string, allow_nil?: false

      filter expr(contains(string_downcase(name), string_downcase(^arg(:search))))
    end
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :email, :string do
      allow_nil? false
      sensitive? true
      public? true
    end

    attribute :website, :string do
      allow_nil? false
      public? true
    end

    attribute :comment, :string do
      allow_nil? false
      public? true
    end

    attribute :archived, :boolean do
      allow_nil? false
      public? true
      default false
    end

    attribute :reference, :string do
      public? true
    end
  end

  relationships do
    has_many :projects_customerassignees, Timed.Projects.Customerassignee do
      destination_attribute :customer_id
      public? true
    end
  end

  identities do
    identity :name_5adc47bc_uniq, [:name]
  end
end
