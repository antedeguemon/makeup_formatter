defmodule MakeupFormatter.HTMLFormatter do
  @moduledoc """
  Transforms a list of fragments into HTML. Based on the original Makeup's HTML
  Formatter.
  """

  require EEx

  @doc """
  Formats a list of fragments into a full HTML page, including stylesheets.

  ## Options

    * style: Highlight theme, for options please visit Makeup documentation.
             Defaults to `:colorful_style`.

  """
  @spec page([MakeupFormatter.fragment()], keyword()) :: String.t()
  def page(fragments, opts \\ []) do
    style = Keyword.get(opts, :style, :colorful_style)
    css = Makeup.Styles.HTML.StyleMap |> apply(style, []) |> Makeup.Styles.HTML.Style.stylesheet()

    fragments
    |> format(opts)
    |> eex_render_page(css)
  end

  @doc """
  Formats a list of fragments into a HTML table.

  ## Options (WIP)

    * line_numbers?: displays line numbers. Defaults to `true`
    * anchor_lines?: adds anchors for line numbers. Defaults to `false`

  ## TODO

    There are some cool functionalities that could be copied from projects like
    [prismjs](https://prismjs.com/#plugins), such as:

    * Collapse lines
    * Highlight TODO, HACK, etc. comments
    * Copy button

    A nice thing to have is support for plugins.

  """
  @spec format([MakeupFormatter.fragment()], keyword()) :: String.t()
  def format(fragments, _opts \\ []) do
    fragments
    |> Enum.filter(fn
      {:line, %{visible?: false}, _tokens} -> false
      _ -> true
    end)
    |> format_fragments_as_html()
    |> eex_render_table()
  end

  defp format_fragments_as_html(fragments) do
    Enum.map(fragments, fn
      {:line, %{number: index} = metadata, tokens} ->
        {:line, metadata, format_tokens(index, tokens)}

      other ->
        other
    end)
  end

  defp format_tokens(line_number, tokens) do
    tokens_html =
      for {type, meta, value} <- tokens do
        css_class = Makeup.Token.Utils.css_class_for_token_type(type)
        data_group_id = if meta[:group_id], do: ~s( data-group-id=""), else: ""
        # TODO: Use wrapped structure

        ~s(<span class="#{css_class}"#{data_group_id} phx-click="token_click" phx-value-data="#{value}" phx-value-line_number="#{line_number}">#{value}</span>)
      end

    Enum.join(tokens_html, "")
  end

  #
  # Functions generators for EEx templates
  #

  @templates [
    eex_render_page: {"page.html.eex", [:inner_html, :css]},
    eex_render_table: {"table.html.eex", [:fragments]},
    eex_render_row: {"row.html.eex", [:fragment]}
  ]

  @templates_path "html_formatter/"

  for {function, {file, arguments}} <- @templates do
    EEx.function_from_file(
      :defp,
      function,
      Path.join(__DIR__, @templates_path <> file),
      arguments,
      trim: true
    )
  end
end
