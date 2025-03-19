defmodule Timed.Accounts do
  @moduledoc false
  use Ash.Domain, otp_app: :timed, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Timed.Accounts.Token
    resource Timed.Accounts.User
  end
end
