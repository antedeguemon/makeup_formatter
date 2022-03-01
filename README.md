# MakeupFormatter

(Experimental stage)

MakeupFormatter is a formatter for [Makeup](https://github.com/elixir-makeup/makeup) 
that provides some cool extra features:

- Displaying line numbers
- Inserting HTML elements into your highlighted code
- It is also compatible with [Phoenix Live View](https://github.com/phoenixframework/phoenix_live_view)

Check a demo of code highlighted by Makeup using MakeupFormatter
[here](https://vicente.pl/code/code.html).

## Running

In a `iex -S mix` session:

```elixir
# Uses Makeup lexer to transform code into list of Makeup tokens
tokens = "lib/makeup_formatter/tokens.ex" |> File.read!() |> Makeup.Lexers.ElixirLexer.lex()

# Transforms Makeup tokens into a list of fragments. These are MakeupFormatter
# structures which can be operated over.
fragments = MakeupFormatter.to_fragments(tokens)

# Defines a HTML element to be inserted in the highlighted code
element = [
  "<div>",
  "<p>This is a comment at some line generated by the new HTML formatter for Makeup.</p>",
  "<p>I have no idea what this line does!</p>",
  "</div>"
]

# Appends above element into some lines
fragments = \
  fragments \
  |> MakeupFormatter.Fragments.append_html(element, line: 1) \
  |> MakeupFormatter.Fragments.append_html(element, line: 5) \
  |> MakeupFormatter.Fragments.append_html(element, line: 20)

# Formats fragments into a HTML page, including stylesheet
html = MakeupFormatter.format_page(fragments, style: :perldoc_style)

# You can also use `format/1` to format only the highlighted code
## html = MakeupFormatter.format(fragments)

# Generated HTML containing highlighted code is saved to `priv/code.html` :)
File.write!("priv/code.html", html)
```
