defmodule Timed.Tracking do
  @moduledoc false
  use Ash.Domain, otp_app: :timed, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Timed.Tracking.Attendance
    resource Timed.Tracking.Absence
    resource Timed.Tracking.Activity

    resource Timed.Tracking.Report do
      define :get_reports, action: :newest
    end
  end
end
