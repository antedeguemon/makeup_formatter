defmodule MakeupFormatter.Fragments.Mutations do
  @doc """
  Mutates line metadata using a given function.
  """
  @spec mutate_metadata([MakeupFormatter.fragment()], function()) :: [MakeupFormatter.fragment()]
  def mutate_metadata(fragments, function) do
    Enum.map(fragments, fn
      {:line, metadata, tokens} -> {:line, function.(metadata), tokens}
      other -> other
    end)
  end
end
