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

  alias Timed.Employment.User

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
    attribute :duration, constant("15")
    attribute :comment, &Faker.Lorem.sentence/0
    attribute :not_billable, choose([true, false])
    attribute :billed, choose([true, false])
    attribute :date, fn _ -> Faker.Date.backward(5) end

    auto_build([:task, :user])
  end

  factory User do
    attribute :password, constant("password")
    attribute :is_superuser, choose([true, false])
    attribute :username, &Faker.Internet.user_name/0
    attribute :first_name, &Faker.Person.first_name/0
    attribute :last_name, &Faker.Person.last_name/0
    attribute :email, &Faker.Internet.email/0
    attribute :is_staff, choose([true, false])
    attribute :is_active, choose([true, false])
    attribute :date_joined, fn _ -> Faker.Date.backward(5) end
    attribute :tour_done, choose([true, false])
    attribute :is_accountant, choose([true, false])
  end
end
