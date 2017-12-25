
defmodule DiscTree do

  # Parse a line
  def parse_line(line) do
    line_format = ~r/([a-z]+) \((\d+)\)( -> (.*))?/
    [_line, name, weight | maybe_children] = Regex.run(line_format, line)
    children = get_children(maybe_children)
    {weight, _} = Integer.parse(weight)
    {name, weight, children}
  end

  # Parse the children that possibly exist in the line
  def get_children([]), do: []

  def get_children([_, children]) do
    children
      |> String.split(",")
      |> Enum.map(&String.trim/1)
  end

  def parse_tree(lines, nodes \\ %{}, orphans \\ %{})

  def parse_tree([], nodes, orphans) do
    root_name = find_root nodes, orphans
    into_tree root_name, nodes
  end

  def parse_tree([line | lines], nodes, orphans) do
    {name, weight, children} = parse_line line
    nodes = Map.put(nodes, name, %{name: name, weight_of_self: weight, children: children})
    orphans = Map.put(orphans, name, :true)
    parse_tree lines, nodes, orphans
  end

  # Return the name of the root node
  def find_root(nodes, orphans) do
    all_children = Enum.flat_map(nodes, fn {_name, value} -> value.children end)
    [root] = orphans
      |> Map.drop(all_children)
      |> Map.keys
    IO.puts "Root node is #{root}"
    root
  end

  # Check if children have matching weight

  def child_weights_match?([]), do: :true

  def child_weights_match?([first | rest]) do
    child_weights_match? rest, first
  end

  defp child_weights_match?([], _weight), do: :true

  defp child_weights_match?([child | rest], weight) do
    if child === weight do
      child_weights_match? rest, weight
    else
      :false
    end
  end


  def into_tree(name, nodes) do
    self = nodes[name]
    children = for child_name <- self.children do
      into_tree(child_name, nodes)
    end

    weights_of_children = for child <- children, do: child.weight
    weight_of_children = Enum.sum(weights_of_children)

    if not child_weights_match? weights_of_children do
      IO.puts "---"
      IO.puts "Differing nodes, do the calculation yourself:"
      for child <- children do
        IO.puts "#{child.name}, #{child.weight_of_self}, #{child.weight}"
      end
      IO.puts "---"
      throw "found"
    end

    self
      |> Map.replace!(:children, children)
      |> Map.put(:weight_of_children, weight_of_children)
      |> Map.put(:weight, self.weight_of_self + weight_of_children)
  end
end

try do
  "day7-example.txt"
    |> File.stream!
    |> Enum.to_list
    |> DiscTree.parse_tree
catch
  "found" -> :ok
end

try do
  "day7-input.txt"
    |> File.stream!
    |> Enum.to_list
    |> DiscTree.parse_tree
catch
  "found" -> :ok
end
