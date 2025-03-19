defmodule Timed.Accounts.User do
  @moduledoc false
  use Ash.Resource,
    otp_app: :timed,
    domain: Timed.Accounts,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication],
    data_layer: AshPostgres.DataLayer

  authentication do
    add_ons do
      log_out_everywhere do
        apply_on_password_change? true
      end
    end

    tokens do
      enabled? true
      token_resource Timed.Accounts.Token
      signing_secret Timed.Secrets
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end
  end

  postgres do
    table "users"
    repo Timed.Repo
  end

  actions do
    defaults [:read]

    read :get_by_subject do
      description "Get a user by the subject claim in a JWT"
      argument :subject, :string, allow_nil?: false
      get? true
      prepare AshAuthentication.Preparations.FilterBySubject
    end
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      forbid_if always()
    end
  end

  attributes do
    uuid_primary_key :id
  end
end
