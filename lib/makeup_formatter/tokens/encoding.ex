defmodule MakeupFormatter.Tokens.Encoding do
  @moduledoc """
  Contains functions related to encoding token values. Extracted from original
  Makeup's HTML Formatter module.
  """

  @spec escape_token(Makeup.Lexer.Types.t()) :: Makeup.Lexer.Types.t()
  def escape_token({type, meta, value}) do
    escaped_value = value |> escape() |> List.to_string()

    {type, meta, escaped_value}
  end

  defp escape(iodata) when is_list(iodata) do
    iodata
    # TODO: Replace with a `List.flatten/1` call
    |> :lists.flatten()
    |> Enum.map(&escape_for/1)
  end

  defp escape(other) when is_binary(other), do: escape_for(other)
  defp escape(c) when is_integer(c), do: [escape_for(c)]

  defp escape_for(?&), do: "&amp;"
  defp escape_for(?<), do: "&lt;"
  defp escape_for(?>), do: "&gt;"
  defp escape_for(?"), do: "&quot;"
  defp escape_for(?'), do: "&#39;"
  defp escape_for(c) when is_integer(c) and c <= 127, do: c
  defp escape_for(c) when is_integer(c) and c >= 128, do: <<c::utf8>>

  defp escape_for(string) when is_binary(string) do
    string
    |> to_charlist()
    |> Enum.map(&escape_for/1)
  end
end
