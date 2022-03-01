defmodule MakeupFormatter.TokensTest do
  use ExUnit.Case, async: true

  alias Makeup.Lexers.ElixirLexer
  alias MakeupFormatter.Tokens

  test "expands tags when a new line is found" do
    moduledoc = ~s(@moduledoc """\nStart\n\nEnd\n""")

    fragments = moduledoc |> ElixirLexer.lex() |> Tokens.to_fragments()

    assert fragments == [
             {:line, %{number: 1, visible?: true},
              [
                {:name_attribute, %{language: :elixir}, "@moduledoc"},
                {:whitespace, %{language: :elixir}, " "},
                {:string, %{language: :elixir}, "&quot;&quot;&quot;"}
              ]},
             {:line, %{number: 2, visible?: true}, [{:string, %{language: :elixir}, "Start"}]},
             {:line, %{number: 3, visible?: true}, [{:string, %{language: :elixir}, ""}]},
             {:line, %{number: 4, visible?: true}, [{:string, %{language: :elixir}, "End"}]},
             {:line, %{number: 5, visible?: true},
              [{:string, %{language: :elixir}, "&quot;&quot;&quot;"}]}
           ]
  end
end
