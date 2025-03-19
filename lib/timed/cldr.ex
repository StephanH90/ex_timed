defmodule Timed.Cldr do
  @moduledoc """
  Calendar module. Can be extended with different packages to support things like relative times, etc.
  """
  use Cldr,
    locales: ["en"],
    default_locale: "en"
end
