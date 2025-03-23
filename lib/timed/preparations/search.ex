defmodule Timed.Preparations.Search do
  @moduledoc """
  Searches the name attribute, orders alphabetically by name and limits the results to 10

  ## Example:

      read :search do
          argument :search, :string, allow_nil?: false
          prepare Timed.Preparations.Search
      end
  """
  use Ash.Resource.Preparation

  @impl true
  def prepare(query, _opts, _context) do
    query
    |> Ash.Query.filter(
      expr(
        contains(string_downcase(name), string_downcase(^Ash.Query.get_argument(query, :search)))
      )
    )
    |> Ash.Query.sort(:name)
    |> Ash.Query.limit(10)
  end
end
