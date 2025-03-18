defmodule Timed.Projects do
  use Ash.Domain, otp_app: :timed, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Timed.Projects.Billingtype
    resource Timed.Projects.Costcenter

    resource Timed.Projects.Customer do
      define :get_customers, action: :alphabetically
      define :search_customers, action: :search, args: [:search]
    end

    resource Timed.Projects.Customerassignee
    resource Timed.Projects.Task
    resource Timed.Projects.Project
  end
end
