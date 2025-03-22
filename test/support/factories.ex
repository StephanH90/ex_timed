defmodule Timed.Test.Factories do
  @moduledoc """
  Factory definitions for Timed. To use these you need to `use Timed.Test.Factories` in your test module.
  After that you can create factories using `insert!`.
  """
  use Smokestack

  alias Timed.Projects.Billingtype
  alias Timed.Projects.Costcenter
  alias Timed.Projects.Customer
  alias Timed.Projects.Project
  alias Timed.Projects.Task

  alias Timed.Tracking.Report

  factory Customer do
    attribute :name, &Faker.Person.name/0
    attribute :email, &Faker.Internet.email/0
    attribute :website, &Faker.Internet.url/0
    attribute :comment, &Faker.Lorem.sentence/0
    attribute :archived, choose([true, false])
  end

  factory Project do
    attribute :name, &Faker.Person.name/0
    attribute :comment, &Faker.Lorem.sentence/0
    auto_build([:customer, :billing_type, :cost_center])
  end

  factory Billingtype do
    attribute :name, &Faker.Person.name/0
  end

  factory Costcenter do
    attribute :name, &Faker.Person.name/0
  end

  factory Task do
    attribute :name, &Faker.Person.name/0

    auto_build([:cost_center, :project])
  end

  factory Report do
    attribute :duration, fn _ -> "15" end
    attribute :comment, &Faker.Lorem.sentence/0
    attribute :not_billable, choose([true, false])
    attribute :billed, choose([true, false])
    attribute :date, fn _ -> Faker.Date.backward(5) end

    auto_build([:task])
  end
end
