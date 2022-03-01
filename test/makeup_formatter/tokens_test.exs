defmodule MakeupFormatter.TokensTest do
  use ExUnit.Case, async: true

  alias Makeup.Lexers.ElixirLexer
  alias MakeupFormatter.Fragments.Metadata
  alias MakeupFormatter.Tokens

  test "expands tags when a new line is found" do
    moduledoc = ~s(@moduledoc """\nStart\n\nEnd\n""")

    fragments = moduledoc |> ElixirLexer.lex() |> Tokens.to_fragments()

    assert fragments == [
             {:line, %Metadata{number: 1},
              [
                {:name_attribute, %{language: :elixir}, "@moduledoc"},
                {:whitespace, %{language: :elixir}, " "},
                {:string, %{language: :elixir}, "&quot;&quot;&quot;"}
              ]},
             {:line, %Metadata{number: 2}, [{:string, %{language: :elixir}, "Start"}]},
             {:line, %Metadata{number: 3}, [{:string, %{language: :elixir}, ""}]},
             {:line, %Metadata{number: 4}, [{:string, %{language: :elixir}, "End"}]},
             {:line, %Metadata{number: 5},
              [{:string, %{language: :elixir}, "&quot;&quot;&quot;"}]}
           ]
  end
end
