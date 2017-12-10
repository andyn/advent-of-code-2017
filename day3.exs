
# Seed for generating the grid
seed = 347991

defmodule SpiralGrid do

  # Create a new stream that generates the grid for first star
  def stream do
    Stream.unfold(nil, &next/1)
  end

  def next(nil) do
    # State machine
    state = %{
      grid: %{location = {0, 0} => 1, number = 1 => {0, 0}},
      x: 0, y: 0, number: 1,
      to_go: 1, length: 1, direction: :right
    }
    {{number, location}, state}
  end

  # Corners, change the direction and then return the next square
  def next(state = %{to_go: 0}) do
    # Calculate new direction and grid side length
    {direction, length} =
      next_direction_and_length state[:direction], state[:length]
    state = state
      |> Map.replace!(:direction, direction)
      |> Map.replace!(:length, length)
      |> Map.replace!(:to_go, length)
    # Do the next step
    next state
  end

  # Non-corners, i.e. sides. Return the next square
  def next(state) do
    location = {x, y} = next_x_and_y state[:x], state[:y], state[:direction]
    # Update the state machine
    state = state
      # |> Map.replace!(:grid, grid)
      |> Map.replace!(:x, x)
      |> Map.replace!(:y, y)
      |> Map.replace!(:to_go, state[:to_go] - 1)
      |> Map.replace!(:number, number = state[:number] + 1)
    grid = state[:grid]
      |> Map.put(location, number)
      |> Map.put(number, location)
    state = state |> Map.replace(:grid, grid)

    {{number, location}, state}  # Grid value for star 1
  end

  # Get the x and y coordinates for the next square
  defp next_x_and_y(x, y, :right), do: {x + 1, y}
  defp next_x_and_y(x, y, :up),    do: {x    , y + 1}
  defp next_x_and_y(x, y, :left),  do: {x - 1, y}
  defp next_x_and_y(x, y, :down),  do: {x    , y - 1}

  # Get the direction and length of the side that is up next
  defp next_direction_and_length(:right, distance), do: {:up,    distance    }
  defp next_direction_and_length(:up,    distance), do: {:left,  distance + 1}
  defp next_direction_and_length(:left,  distance), do: {:down,  distance    }
  defp next_direction_and_length(:down,  distance), do: {:right, distance + 1}

end

# First star
[{_, {x, y}}] = SpiralGrid.stream
  |> Stream.drop(seed - 1)
  |> Stream.take(1)
  |> Enum.to_list

distance = abs(x) + abs(y)
IO.puts("First star: Manhattan distance for coordinates (#{x},#{y}) is #{distance}")


# The second star is so different that refactoring
# any code above is out of question
defmodule SpiralGrid2 do

  def stream do
    Stream.unfold(nil, &next/1)
  end

  def next(nil) do
    # State machine
    state = %{
      grid: %{{0, 0} => 1, number = 1 => {0, 0}},
      x: 0, y: 0,
      to_go: 1, length: 1, direction: :right
    }
    {number, state}
  end

  # Corners, change the direction and then return the next square
  def next(state = %{to_go: 0}) do
    # Calculate new direction and grid side length
    {direction, length} =
      next_direction_and_length state[:direction], state[:length]
    state = state
      |> Map.replace!(:direction, direction)
      |> Map.replace!(:length, length)
      |> Map.replace!(:to_go, length)
    # Do the next step
    next state
  end

  # Non-corners, i.e. sides. Return the next square
  def next(state) do
    location = {x, y} = next_x_and_y state[:x], state[:y], state[:direction]
    state = state
      # |> Map.replace!(:grid, grid)
      |> Map.replace!(:x, x)
      |> Map.replace!(:y, y)
      |> Map.replace!(:to_go, state[:to_go] - 1)

    x = state[:x]
    y = state[:y]
    adjacent = for xi <- (x - 1)..(x + 1),
                   yi <- (y - 1)..(y + 1),
                   not (x == xi and y == yi),
                   do: Map.get(state[:grid], {xi, yi}, 0)

    number = adjacent |> Enum.reduce(fn val, acc -> val + acc end)

    grid = state[:grid]
      |> Map.put(location, number)
      |> Map.put(number, location)
    state = state |> Map.replace(:grid, grid)

    {number, state}  # Grid value for star 1
  end

  # Get the x and y coordinates for the next square
  defp next_x_and_y(x, y, :right), do: {x + 1, y}
  defp next_x_and_y(x, y, :up),    do: {x    , y + 1}
  defp next_x_and_y(x, y, :left),  do: {x - 1, y}
  defp next_x_and_y(x, y, :down),  do: {x    , y - 1}

  # Get the direction and length of the side that is up next
  defp next_direction_and_length(:right, distance), do: {:up,    distance    }
  defp next_direction_and_length(:up,    distance), do: {:left,  distance + 1}
  defp next_direction_and_length(:left,  distance), do: {:down,  distance    }
  defp next_direction_and_length(:down,  distance), do: {:right, distance + 1}

end

# Seconds star
[result] = SpiralGrid2.stream
  |> Stream.drop_while(fn val -> val < seed end)
  |> Stream.take(1)
  |> Enum.to_list

IO.puts("Second star: First value over #{seed} is #{result}")
