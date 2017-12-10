
defmodule Cpu do

  def init(instructions) do
    init instructions,
         %{memory: %{}, memory_size: 0, pc: 0, cycles: 0}
  end

  def init([], cpu), do: cpu

  def init([instruction | tail], cpu) do
    cpu = cpu
      |> put_in([:memory, cpu[:memory_size]], instruction)
      |> put_in([:memory_size], cpu[:memory_size] + 1)
    init tail, cpu
  end

  # Out of bounds, return cpu in current state
  def run(cpu = %{pc: pc, memory_size: size}) when pc < 0 or pc >= size, do: cpu

  # Non-empty memory, run
  def run(cpu = %{memory: mem, pc: pc, cycles: cycles}) do
    instruction = Map.get(mem, pc)
    # Execute
    write_back = instruction + 1
    # Update
    cpu = cpu
      |> put_in([:memory, pc], write_back)
      |> put_in([:cycles], cycles + 1)
      |> put_in([:pc], pc + instruction)
    # Next cycle
    run(cpu)

  end

  def program_counter(cpu), do: cpu[:program_counter]

  def cycles_used(cpu), do: cpu[:cycles]

end


count = File.stream!("day5-example.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&Integer.parse/1)
  |> Stream.map(fn {int, _} -> int end)
  |> Enum.to_list
  |> Cpu.init
  |> Cpu.run
  |> Cpu.cycles_used
IO.puts "Example: Cycles used after finishing: #{count}"

count = File.stream!("day5-input.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&Integer.parse/1)
  |> Stream.map(fn {int, _} -> int end)
  |> Enum.to_list
  |> Cpu.init
  |> Cpu.run
  |> Cpu.cycles_used
IO.puts "First star: Cycles used after finishing: #{count}"
