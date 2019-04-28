defmodule Roman do
  @values [
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t()
  def numerals(0), do: ""

  def numerals(number) do
    {value, letters} = @values |> get_largest_value(number)
    letters <> numerals(number - value)
  end

  # Find the largest value that will subtract into the number
  defp get_largest_value([{value, letters} | _rest], number)
       when number >= value do
    {value, letters}
  end

  defp get_largest_value([_head | rest], number) do
    get_largest_value(rest, number)
  end
end
