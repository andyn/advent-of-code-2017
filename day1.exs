
defmodule Day1 do

    def sum_matching_elements(list1, list2) do
        sum_matching_elements(list1, list2, 0)
    end

    def sum_matching_elements([head | tail1], [head | tail2], sum) do
         sum_matching_elements(tail1, tail2, sum + head)
    end

    def sum_matching_elements([_ | tail1], [_ | tail2], sum) do
        sum_matching_elements(tail1, tail2, sum)
    end

    def sum_matching_elements([], _, sum), do: sum
    def sum_matching_elements(_, [], sum), do: sum

    def digit_to_integer(char), do: char - ?0
end

defmodule Day1a do
    def sum_adjacent_wrap(list = [head | tail]) do
        Day1.sum_matching_elements(list, tail ++ [head])
    end
end

defmodule Day1b do
    def sum_halfway_wrap(list) do
        half_length = length(list) |> div(2)
        [first_half, second_half] = Enum.chunk(list, half_length, half_length)
        Day1.sum_matching_elements(list, second_half ++ first_half, 0)
    end
end


{:ok, handle} = File.open("day1.txt")
input = IO.read(handle, :all)
  |> String.trim
  |> to_charlist
  |> Enum.map(&Day1.digit_to_integer/1)

answer_a = Day1a.sum_adjacent_wrap input
answer_b = Day1b.sum_halfway_wrap input

IO.puts "First star: #{answer_a}, second star: #{answer_b}"
