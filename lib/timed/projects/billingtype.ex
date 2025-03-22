defmodule Timed.Projects.Billingtype do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Projects,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "projects_billingtype"
    repo Timed.Repo

    custom_indexes do
      index [:name] do
        name "projects_billingtype_name_945d6bac_like"
      end
    end

    identity_index_names name_key: "projects_billingtype_name_key"
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

  identities do
    identity :name_key, [:name]
  end
end
