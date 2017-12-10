
defmodule Day2 do

  @doc """
  Helper functions for Advent of Code 2017, day 2
  """

  def parse_integers_from_string(string) do
    integer_strings = string |> String.split
    for each <- integer_strings,
        {integer, _} = Integer.parse(each), do: integer
  end

  def find_min_max([integer | tail]) do
    find_min_max tail, integer, integer
  end

  def find_min_max([], minimum, maximum) do
    {minimum, maximum}
  end

  def find_min_max([integer | tail], minimum, maximum) do
    find_min_max tail, (min minimum, integer), (max maximum, integer)
  end

  # Find the pair of evenly divisible integers in a list, return the division
  def find_evenly_divisible(integers) do
    for divisible <- integers,
        divisor <- integers -- [divisible],
        # divisor != 0,
        rem(divisible, divisor) == 0,
        do: div(divisible, divisor)
  end

  def sum(integers), do: integers |> Enum.reduce(fn val, acc -> val + acc end)

end


# Read the input
integers = File.stream!("day2.txt")
  |> Stream.map(&Day2.parse_integers_from_string/1)
  |> Enum.to_list

# First star
sum_of_min_max = integers
  |> Enum.map(&Day2.find_min_max/1)
  |> Enum.map(fn {min, max} -> max - min end)
  |> Day2.sum

IO.puts "Sum of min-max-differences: #{sum_of_min_max}"

# Second star
sum_of_divisible_pairs = integers
  |> Enum.map(&Day2.find_evenly_divisible/1)
  |> Enum.map(fn [first | _] -> first end)
  |> Day2.sum

IO.puts "Sum of divisible pairs on each line: #{sum_of_divisible_pairs}"
