defmodule Timed.Test.DurationFormatter do
  @moduledoc false

  use Timed.DataCase, async: true

  alias Timed.DurationFormatter

  describe "format/1" do
    test "formats to the correct string" do
      assert DurationFormatter.format(0) === "00:00"
      assert DurationFormatter.format(1) === "00:15"
      assert DurationFormatter.format(5) === "00:15"
      assert DurationFormatter.format(60) === "01:00"
      assert DurationFormatter.format(61) === "01:15"
      assert DurationFormatter.format(124) === "02:15"
    end
  end

  describe "parse/1" do
    test "parses the correct duration" do
      assert DurationFormatter.parse!("") === 0
      assert DurationFormatter.parse!(nil) === 0
      assert DurationFormatter.parse!("3") === 15
      assert DurationFormatter.parse!("00:00") === 0
      assert DurationFormatter.parse!("00:15") === 15
      assert DurationFormatter.parse!("01:00") === 60
      assert DurationFormatter.parse!("01:15") === 75
      assert DurationFormatter.parse!("02:15") === 135
    end
  end
end
