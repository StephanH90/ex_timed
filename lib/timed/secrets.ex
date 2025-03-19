defmodule Timed.Secrets do
  @moduledoc false
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Timed.Accounts.User, _opts) do
    Application.fetch_env(:timed, :token_signing_secret)
  end
end
