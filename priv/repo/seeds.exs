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

# create a dummy user
Ash.create!(
  Timed.Employment.User,
  %{
    password: "foobar",
    first_name: "foo",
    last_name: "bar",
    email: "foobar@foobar.com",
    tour_done: true,
    is_accountant: false,
    is_active: true,
    is_superuser: false,
    username: "foobar",
    is_staff: true,
    date_joined: Date.utc_today()
  }
)

billing_type =
  Ash.create!(
    Timed.Projects.Billingtype,
    %{name: "some billingtype"}
  )

cost_center =
  Ash.create!(
    Timed.Projects.Costcenter,
    %{name: "some costcenter"}
  )

customer =
  Ash.create!(
    Timed.Projects.Customer,
    %{
      name: "foo customer",
      email: "customer@adfinis.com",
      website: "http://fobar.com",
      comment: "no comment"
    }
  )

project =
  Ash.create!(
    Timed.Projects.Project,
    %{
      name: "a great project",
      comment: "but no comment",
      customer_id: customer.id,
      billing_type_id: billing_type.id,
      cost_center_id: cost_center.id
    }
  )

Ash.create(
  Timed.Projects.Task,
  %{name: "a great task", cost_center_id: cost_center.id, project_id: project.id}
)
