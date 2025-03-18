defmodule Timed.Employment do
  use Ash.Domain, otp_app: :timed, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Timed.Employment.User
  end
end
