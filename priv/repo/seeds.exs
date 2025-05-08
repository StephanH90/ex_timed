# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Timed.Repo.insert!(%Timed.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Timed.Projects.Costcenter
alias Timed.Projects.Billingtype
alias Timed.Projects.Customer
alias Timed.Projects.Project
alias Timed.Projects.Task
alias Timed.Employment.User
alias Timed.Tracking.Report

cost_centers =
  Enum.map(1..10, fn i ->
    Ash.Seed.seed!(Costcenter, %{name: "Cost center #{i}"})
  end)

billing_types =
  Enum.map(1..5, fn i ->
    Ash.Seed.seed!(Billingtype, %{name: "Billing type #{i}"})
  end)

customers =
  Enum.map(1..10, fn i ->
    Ash.Seed.seed!(Customer, %{
      name: "Customer #{i}",
      email: "customer#{i}@example.com",
      website: "http://example.com",
      comment: "Customer comment #{i}"
    })
  end)

projects =
  Enum.map(1..20, fn i ->
    Ash.Seed.seed!(Project, %{
      name: "Project #{i}",
      comment: "Comment for project #{i}",
      customer_id: Enum.random(customers).id,
      billing_type_id: Enum.random(billing_types).id,
      cost_center_id: Enum.random(cost_centers).id
    })
  end)

tasks =
  Enum.map(1..100, fn i ->
    Ash.Seed.seed!(Task, %{
      name: "Task #{i}",
      comment: "Comment for task #{i}",
      project_id: Enum.random(projects).id,
      cost_center_id: Enum.random(cost_centers).id,
      start_time: DateTime.utc_now(),
      end_time: DateTime.add(DateTime.utc_now(), 3600)
    })
  end)

users =
  Enum.map(1..20, fn i ->
    Ash.Seed.seed!(User, %{
      username: "User #{i}",
      first_name: "First #{i}",
      last_name: "Last #{i}",
      email: "user#{i}@example.com",
      password: "foo",
      is_superuser: false,
      is_staff: false,
      is_active: true,
      date_joined: DateTime.utc_now(),
      tour_done: true,
      is_accountant: false
    })
  end)

Enum.each(1..1000, fn i ->
  Ash.Seed.seed!(Report, %{
    comment: "Comment for report #{i}",
    duration: "90",
    not_billable: Enum.random([true, false]),
    billed: Enum.random([true, false]),
    date: DateTime.utc_now() |> Date.add(:rand.uniform(365) * -1),
    task_id: Enum.random(tasks).id,
    user_id: Enum.random(users).id
  })
end)
