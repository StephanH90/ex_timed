defmodule Timed.Preparations.Alphabetically do
  @moduledoc """
  Orders alphabetically by the given attribute. Limits results to 10.

  ## Example:

      read :alphabetically do
          prepare {Timed.Preparations.Alphabetically, attribute: :name}
      end
  """
  use Ash.Resource.Preparation

  @impl true
  def prepare(query, opts, _context) do
    query
    |> Ash.Query.sort(opts[:attribute])
    |> Ash.Query.limit(10)
  end
end
