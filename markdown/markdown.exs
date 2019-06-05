defmodule Markdown do
  @leading_strong_regex ~r/^#{"__"}{1}/
  @trailing_strong_regex ~r/#{"__"}{1}$/
  @leading_em_regex ~r/^[#{"_"}{1}][^#{"_"}+]/
  @trailing_em_regex ~r/[^#{"_"}{1}]/

  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.map_join(&to_html/1)
    |> add_outer_list_tag()
  end

  defp to_html(line = "#" <> _), do: to_header_tag(line)
  defp to_html("* " <> line), do: to_line_item_tag(line)
  defp to_html(line), do: to_paragraph_tag(line)

  defp parse_header_md_level(md_header) do
    [h | t] = String.split(md_header)
    {String.length(h), Enum.join(t, " ")}
  end

  defp to_line_item_tag(content) do
    "<li>#{convert_content(content)}</li>"
  end

  defp to_header_tag(line) do
    {level, content} = parse_header_md_level(line)
    "<h#{level}>#{content}</h#{level}>"
  end

  defp to_paragraph_tag(content) do
    "<p>#{convert_content(content)}</p>"
  end

  defp convert_content(content) do
    content
    |> String.split()
    |> Enum.map(&replace_md_with_tag/1)
    |> Enum.join(" ")
  end

  defp replace_md_with_tag(words) do
    words
    |> replace_prefix_md()
    |> replace_suffix_md()
  end

  defp replace_prefix_md(word) do
    cond do
      word =~ @leading_strong_regex ->
        String.replace(word, @leading_strong_regex, "<strong>", global: false)

      word =~ @leading_em_regex ->
        String.replace(word, ~r/_/, "<em>", global: false)

      true ->
        word
    end
  end

  defp replace_suffix_md(word) do
    cond do
      word =~ @trailing_strong_regex ->
        String.replace(word, @trailing_strong_regex, "</strong>")

      word =~ @trailing_em_regex ->
        String.replace(word, ~r/_/, "</em>")

      true ->
        word
    end
  end

  defp add_outer_list_tag(html) do
    html
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
