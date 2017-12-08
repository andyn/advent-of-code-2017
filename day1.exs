
defmodule Day1a do

    def sum_adjacent_wrap(list = [head | _]) do
        sum_adjacent(list ++ [head])
    end

    defp sum_adjacent(list), do: sum_adjacent(list, 0)

    defp sum_adjacent([head, head | tail], sum) do
        sum_adjacent([head | tail], sum + head - ?0)
    end

    defp sum_adjacent([_ | tail], sum) do
        sum_adjacent(tail, sum)
    end

    defp sum_adjacent([], sum) do
        sum
    end
end

defmodule Day1b do
    def sum_halfway_wrap(list) do
        half_length = length(list) |> div(2)
        [first_half, second_half] = Enum.chunk(list, half_length, half_length)
        sum_lists(list, second_half ++ first_half, 0)
    end

    defp sum_lists([head | tail1], [head | tail2], sum) do
         sum_lists(tail1, tail2, sum + head - ?0)
    end

    defp sum_lists([_ | tail1], [_ | tail2], sum) do
        sum_lists(tail1, tail2, sum)
    end

    defp sum_lists([], _, sum), do: sum
    defp sum_lists(_, [], sum), do: sum
end


{:ok, handle} = File.open("day1.txt")
input = IO.read(handle, :all)
  |> String.trim
  |> to_charlist

answer_a = Day1a.sum_adjacent_wrap input
answer_b = Day1b.sum_halfway_wrap input

IO.puts "First star: #{answer_a}, second star: #{answer_b}"
