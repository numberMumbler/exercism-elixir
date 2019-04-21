defmodule Bob do
  defp empty?(nil), do: true
  defp empty?(message), do: String.trim(message) == ""

  defp shouting?(message) do
    String.upcase(message) == message and String.downcase(message) != message
  end

  defp question?(message), do: String.ends_with?(message, "?")

  defp shouting_question?(message), do: shouting?(message) and question?(message)

  def hey(input) do
    cond do
      empty?(input) -> "Fine. Be that way!"
      shouting_question?(input) -> "Calm down, I know what I'm doing!"
      shouting?(input) -> "Whoa, chill out!"
      question?(input) -> "Sure."
      true -> "Whatever."
    end
  end
end
