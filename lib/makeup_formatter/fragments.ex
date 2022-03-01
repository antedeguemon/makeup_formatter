defmodule MakeupFormatter.Fragments do
  @moduledoc """
  Contains operations over highlighted blocks.
  """

  alias MakeupFormatter.Fragments.Mutations

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
    index =
      Enum.find_index(fragments, fn
        {:line, %{line: line}, _} -> line == line_number
        _ -> false
      end)

    List.insert_at(fragments, index + 1, {:html, element})
  end

  def add_class(fragments, css_class, line: target_line) do
    Mutations.mutate_metadata(fragments, fn
      %{line_number: ^target_line} = metadata ->
        Map.put(metadata.html_attributes, :class, css_class)

      metadata ->
        metadata
    end)
  end

  def hide(fragments, from_line: from_line, to_line: to_line) do
    Mutations.mutate_metadata(fragments, fn
      %{line_number: line_number} = metadata
      when line_number >= from_line and line_number <= to_line ->
        %{metadata | visible?: false}

      metadata ->
        metadata
    end)
  end

  def hide(fragments) do
    Mutations.mutate_metadata(fragments, fn metadata -> %{metadata | visible?: false} end)
  end

  def show(fragments, from_line: from_line, to_line: to_line) do
    Mutations.mutate_metadata(fragments, fn
      %{line_number: line_number} = metadata
      when line_number >= from_line and line_number <= to_line ->
        %{metadata | visible?: true}

      metadata ->
        metadata
    end)
  end
end
