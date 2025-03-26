defmodule Timed.Employment.User do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Employment,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "employment_user"
    repo Timed.Repo

    custom_indexes do
      index [:username] do
        name "employment_user_username_f3762b2b_like"
      end
    end

    identity_index_names username_key: "employment_user_username_key"
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    integer_primary_key :id

    attribute :password, :string do
      allow_nil? false
      sensitive? true
      public? true
    end

    attribute :last_login, :utc_datetime_usec do
      public? true
    end

    attribute :is_superuser, :boolean do
      allow_nil? false
      public? true
    end

    attribute :username, :string do
      allow_nil? false
      public? true
    end

    attribute :first_name, :string do
      allow_nil? false
      public? true
    end

    attribute :last_name, :string do
      allow_nil? false
      public? true
    end

    attribute :email, :string do
      allow_nil? false
      sensitive? true
      public? true
    end

    attribute :is_staff, :boolean do
      allow_nil? false
      public? true
    end

    attribute :is_active, :boolean do
      allow_nil? false
      public? true
    end

    attribute :date_joined, :utc_datetime_usec do
      allow_nil? false
      public? true
    end

    attribute :tour_done, :boolean do
      allow_nil? false
      public? true
    end

    attribute :is_accountant, :boolean do
      allow_nil? false
      sensitive? true
      public? true
    end
  end

  identities do
    identity :username_key, [:username]
  end
end
