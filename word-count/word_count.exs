defmodule Words do
  @nonword_character ~r/[^a-z0-9ß-ÿ-]/

  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    |> String.split(@nonword_character, trim: true)
    |> Enum.reduce(%{}, fn word, counts -> Map.update(counts, word, 1, &(&1 + 1)) end)
  end
end
