defmodule Timed.Projects do
  @moduledoc false
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

    resource Timed.Projects.Task do
      define :get_tasks_for_project, action: :for_project, args: [:project_id]

      define :search_tasks_for_project,
        action: :search_for_project,
        args: [:project_id, :search]
    end

    resource Timed.Projects.Project do
      define :get_projects_for_customer, action: :for_customer, args: [:customer_id]

      define :search_projects_for_customer,
        action: :search_for_customer,
        args: [:customer_id, :search]
    end
  end
end
