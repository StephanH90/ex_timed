defmodule Timed.Projects.Project do
  @moduledoc false
  use Ash.Resource,
    domain: Timed.Projects,
    data_layer: AshPostgres.DataLayer

  alias Timed.Projects.Billingtype
  alias Timed.Projects.Costcenter
  alias Timed.Projects.Customer

  postgres do
    table "projects_project"
    repo Timed.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    read :for_customer do
      argument :customer_id, :integer, allow_nil?: false
      filter expr(customer_id == ^arg(:customer_id))
    end
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string, constraints: [max_length: 255], allow_nil?: false, public?: true
    attribute :reference, :string, constraints: [max_length: 255], allow_nil?: true, public?: true
    attribute :comment, :string, allow_nil?: false, public?: true
    attribute :archived, :boolean, allow_nil?: false, default: false, public?: true
    attribute :billed, :boolean, allow_nil?: false, default: false, public?: true
    attribute :estimated_time, Timed.Types.Interval, allow_nil?: true, public?: true
    attribute :customer_visible, :boolean, allow_nil?: false, default: false, public?: true

    attribute :remaining_effort_tracking, :boolean,
      allow_nil?: false,
      default: false,
      public?: true

    attribute :total_remaining_effort, Timed.Types.Interval,
      allow_nil?: false,
      public?: true,
      default: 0

    attribute :customer_id, :integer, allow_nil?: false, public?: true
    attribute :billing_type_id, :integer, allow_nil?: false, public?: true
    attribute :cost_center_id, :integer, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :customer, Customer, allow_nil?: false
    belongs_to :billing_type, Billingtype, allow_nil?: false
    belongs_to :cost_center, Costcenter, allow_nil?: false
  end
end
