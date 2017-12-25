
defmodule Memory do

  # Find the maximum in a list, accumulating the already processed
  # items in the list to a temporary stack.
  # Return max,
  def find_max(elements) do
    max_value = Enum.max(elements)
    find_first elements, max_value
  end


  # Find the first matching value in a list, saving the non-matching elements
  # into a stack.
  # If found, return two lists - first one holds the remaining list with
  # the matching element in the head position, the second one the non-matching
  # elements processed in reverse order.
  def find_first(next, previous \\ [], value_to_find)

  def find_first(next = [value_to_find | _], previous, value_to_find) do
    {next, previous}
  end

  def find_first([some_other_value | next], previous, value_to_find) do
    find_first next, [some_other_value | previous], value_to_find
  end


  # Redistribute values, finding a stable state that cannot be further
  # redistributed without hitting a cycle. Also counts the number of cycles
  # until hitting a previous state and the cycle length.
  # Return {mutated state, redistribution count}
  def find_stable_state(state, previous_states \\ %{}, count \\ 0)

  # Found a previous state? Return it and the count
  def find_stable_state(state, previous_states, count) do
    # Elixir cannot function match or guard against maps,
    # as they are not compile-time.
    if Map.has_key?(previous_states, state) do
      cycle_length = count - previous_states[state]
      {state, count, cycle_length}
    else
      states = Map.put(previous_states, state, count)
      new_state = redistribute_largest(state)
      find_stable_state(new_state, states, count + 1)
    end
  end


  # Find the largest integer value in a list, redistributing it over the list
  # in a round-robin order.
  def redistribute_largest(values) do
    {max_and_next, previous} = values |> find_max
    redistribute max_and_next, previous
  end


  # Take the head of the first parameter, redistributing it to the rest
  # of the list, adding one into each element so that the sum of the list says
  # the same. If the end of the list is reached, take the optional second
  # parameter (stack of processed values), reverse it and start again from the
  # beginning.
  def redistribute([value_to_redistribute | next], previous \\ []) do
    redistribute next, [0 | previous], value_to_redistribute
  end

  # Redistribution done? Return the redistributed list.
  def redistribute(next, previous, remaining) when remaining == 0 do
    Enum.reverse(previous, next)
  end

  # End of list? Reverse the previous stack and start from beginning
  def redistribute([], previous, remaining) do
    redistribute Enum.reverse(previous), [], remaining
  end

  # Redistribute one from remaining into the list
  def redistribute([head | next], previous, remaining) do
    redistribute next, [head + 1 | previous], remaining - 1
  end




end

# Verify that the given examples work
[2, 4, 1, 2] = Memory.redistribute_largest [0, 2, 7, 0]
{[2, 4, 1, 2], 5, 4} = Memory.find_stable_state [0, 2, 7, 0]

# Count the personal answer
{:ok, data} = File.read("day6-input.txt")
{_state, count, cycle_length} = data
  |> String.split
  |> Enum.map(&Integer.parse/1)
  |> Enum.map(fn {num, _} -> num end)
  |> Memory.find_stable_state
IO.puts "Hit a cycle after #{count} reallocations, cycle length #{cycle_length}"
