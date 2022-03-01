defmodule MakeupFormatter.Tokens do
  @moduledoc """
  Contains functions for processing Makeup tokens.
  """

  alias MakeupFormatter.Tokens.Encoding

  @doc """
  Transforms a list of tokens from Makeup into a fragments list.
  """
  @spec to_fragments([MakeupFormatter.makeup_token()]) :: list(MakeupFormatter.fragment())
  def to_fragments(tokens) do
    tokens
    |> Enum.map(&Encoding.escape_token/1)
    |> expand_tokens()
    |> build_fragments()
  end

  @doc """
  Expands tokens containing line breaks into new ones. This operation is needed
  to accomodate multilined tokens outside of `<pre></pre>`.

  The result is a 2-dimensional list where each element represents a line.

    ## TODOs

    * Should group_id matching with parent be added to token - specially when
      the parent does not have any (?)
    * Add example to doc

  """
  @spec expand_tokens([MakeupFormatter.makeup_token()]) :: [[MakeupFormatter.makeup_token()]]
  def expand_tokens(tokens) do
    tokens
    |> expand_tokens([[]])
    |> Enum.reverse()
  end

  defp expand_tokens([], acc), do: acc

  defp expand_tokens([{token_type, token_meta, token_value} = token | rest], [top | bottom]) do
    case String.split(token_value, "\n", parts: 2) do
      [_] ->
        expand_tokens(rest, [[token | top] | bottom])

      [pre_break, post_break] ->
        emited_token = {token_type, token_meta, pre_break}
        next_token = {token_type, token_meta, post_break}
        previous_tokens = Enum.reverse([emited_token | top])

        expand_tokens([next_token | rest], [[] | [previous_tokens | bottom]])
    end
  end

  defp build_fragments(lines) do
    lines
    |> Enum.with_index(1)
    |> Enum.map(fn {line, index} ->
      {:line, %{number: index, visible?: true}, line}
    end)
  end
end
