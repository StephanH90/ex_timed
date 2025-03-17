defmodule Timed.Projects do
  use Ash.Domain, otp_app: :timed, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Timed.Projects.Billingtype
    resource Timed.Projects.Costcenter
    resource Timed.Projects.Customer
    resource Timed.Projects.Customerassignee
  end
end
