
defmodule Cpu do

  # Default ALU for first star
  def default_alu(x), do: x + 1

  # ALU for second star
  def complex_alu(x) when x >= 3, do: x - 1
  def complex_alu(x), do: x + 1

  def init(instructions, alu \\ &default_alu/1) do
    init_cpu instructions,
         %{memory: %{}, memory_size: 0, alu: alu, pc: 0, cycles: 0}
  end

  def init_cpu([], cpu), do: cpu

  def init_cpu([instruction | tail], cpu) do
    cpu = cpu
      |> put_in([:memory, cpu[:memory_size]], instruction)
      |> put_in([:memory_size], cpu[:memory_size] + 1)
    init_cpu tail, cpu
  end

  # Out of bounds, return cpu in current state
  def run(cpu = %{pc: pc, memory_size: size}) when pc < 0 or pc >= size, do: cpu

  # Non-empty memory, run
  def run(cpu = %{memory: mem, pc: pc, cycles: cycles, alu: alu}) do
    instruction = Map.get(mem, pc)
    # Execute
    write_back = alu.(instruction)
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
IO.puts "First example: Cycles used after finishing: #{count}"

count = File.stream!("day5-input.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&Integer.parse/1)
  |> Stream.map(fn {int, _} -> int end)
  |> Enum.to_list
  |> Cpu.init
  |> Cpu.run
  |> Cpu.cycles_used
IO.puts "First star: Cycles used after finishing: #{count}"

count = File.stream!("day5-example.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&Integer.parse/1)
  |> Stream.map(fn {int, _} -> int end)
  |> Enum.to_list
  |> Cpu.init(&Cpu.complex_alu/1)
  |> Cpu.run
  |> Cpu.cycles_used
IO.puts "Second example: Cycles used after finishing: #{count}"

count = File.stream!("day5-input.txt")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&Integer.parse/1)
  |> Stream.map(fn {int, _} -> int end)
  |> Enum.to_list
  |> Cpu.init(&Cpu.complex_alu/1)
  |> Cpu.run
  |> Cpu.cycles_used
IO.puts "Second star: Cycles used after finishing: #{count}"
