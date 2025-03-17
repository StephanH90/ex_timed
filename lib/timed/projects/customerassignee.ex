defmodule Timed.Projects.Customerassignee do
  use Ash.Resource,
    domain: Timed.Projects,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "projects_customerassignee"
    repo Timed.Repo

    references do
      reference :projects_customer do
      end
    end
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

    attribute :is_resource, :boolean do
      allow_nil? false
      public? true
    end

    attribute :is_reviewer, :boolean do
      allow_nil? false
      public? true
    end

    attribute :is_manager, :boolean do
      allow_nil? false
      public? true
    end

    attribute :user_id, :integer do
      allow_nil? false
      public? true
    end

    attribute :is_customer, :boolean do
      allow_nil? false
      public? true
    end
  end

  relationships do
    belongs_to :projects_customer, Timed.Projects.Customer do
      source_attribute :customer_id
      allow_nil? false
      attribute_type :integer
      public? true
    end
  end
end
