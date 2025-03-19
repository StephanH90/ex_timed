defmodule Timed.Tracking.Absence do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Tracking,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tracking_absence"
    repo Timed.Repo

    identity_index_names date_user_id_96b8708e_uniq: "tracking_absence_date_user_id_96b8708e_uniq"
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

    attribute :absence_type_id, :integer do
      allow_nil? false
      public? true
    end

    attribute :user_id, :integer do
      allow_nil? false
      public? true
    end
  end

  identities do
    identity :date_user_id_96b8708e_uniq, [:date, :user_id]
  end
end
