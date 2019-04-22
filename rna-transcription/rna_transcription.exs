defmodule RNATranscription do
  defp complement(?G), do: ?C
  defp complement(?C), do: ?G
  defp complement(?T), do: ?A
  defp complement(?A), do: ?U

  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna), do: Enum.map dna, &complement/1
end
