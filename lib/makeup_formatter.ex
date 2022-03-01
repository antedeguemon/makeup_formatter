defmodule MakeupFormatter do
  alias MakeupFormatter.Fragments.Metadata

  @type makeup_token :: Makeup.Lexer.Types.token()

  @type fragment :: line_fragment() | html_fragment()
  @type line_fragment :: {:line, Metadata.t(), list(makeup_token() | wrapper())}
  @type html_fragment :: {:html, Metadata.t(), term()}

  @type wrapper :: {:wrapper, String.t(), html_attributes :: map()}

  @doc delegate_to: {MakeupFormatter.Tokens, :tokens, 1}
  @spec to_fragments([makeup_token()]) :: [fragment()]
  defdelegate to_fragments(tokens), to: MakeupFormatter.Tokens

  @doc delegate_to: {MakeupFormatter.HTMLFormatter, :format, 2}
  @spec format([fragment()], keyword()) :: String.t()
  defdelegate format(tokens, opts \\ []), to: MakeupFormatter.HTMLFormatter, as: :format

  @doc delegate_to: {MakeupFormatter.HTMLFormatter, :page, 2}
  @spec format_page([fragment()], keyword()) :: String.t()
  defdelegate format_page(tokens, opts \\ []), to: MakeupFormatter.HTMLFormatter, as: :page
end
