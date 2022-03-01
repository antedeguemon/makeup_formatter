defmodule MakeupFormatter.Fragments do
  @moduledoc """
  Contains operations over highlighted blocks.
  """

  @spec type(MakeupFormatter.fragment()) :: :line | :html
  def type({:line, _, _}), do: :line
  def type({:html, _}), do: :html

  @doc """
  Appends a HTML fragment into a list of fragments at a specified line.
  """
  @spec append_html([MakeupFormatter.fragment()], term(), line: non_neg_integer()) :: [
          MakeupFormatter.fragment()
        ]
  def append_html(fragments, element, line: line_number) do
    # TODO: Need to chunk_by here
    index =
      Enum.find_index(fragments, fn
        {:line, %{line: line}, _} -> line == line_number
        _ -> false
      end)

    List.insert_at(fragments, index + 1, {:html, element})
  end

  @doc """
  Wraps a token or a list of tokens around a HTML element.
  """
  # @spec wrap([MakeupFormatter.fragment()], function(), term()) :: MakeupFormatter.fragment()
  def wrap(_fragments, _function, _element) do
  end

  def add_class_to_line(fragments, css_class, target_line) do
    Enum.map(fragments, fn
      {:line, %{number: ^target_line} = metadata, tokens} ->
        {:line, Map.put(metadata, :css_class, css_class), tokens}

      other ->
        other
    end)
  end

  def hide(fragments, from_line: from_line, to_line: to_line) do
    Enum.map(fragments, fn
      {:line, %{number: line_number} = attributes, tokens}
      when line_number >= from_line and line_number <= to_line ->
        {:line, %{attributes | visible?: false}, tokens}

      other ->
        other
    end)
  end

  def hide(fragments) do
    Enum.map(fragments, fn
      {:line, metadata, tokens} -> {:line, %{metadata | visible?: false}, tokens}
      other -> other
    end)
  end

  def show(fragments, from_line: from_line, to_line: to_line) do
    Enum.map(fragments, fn
      {:line, %{number: line_number} = metadata, tokens}
      when line_number >= from_line and line_number <= to_line ->
        {:line, %{metadata | visible?: true}, tokens}

      other ->
        other
    end)
  end
end
