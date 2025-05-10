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
      define :get_reports_for_date, action: :for_date, args: [:date]
      # define :get_reports_for_analysis, action: :analysis, args: [:customer_id]

      define :get_reports_within_date_range,
        action: :within_date_range,
        args: [:start_date, :end_date]
    end

    resource Timed.Statistics.Day
    resource WeeklyOverview
  end
end
