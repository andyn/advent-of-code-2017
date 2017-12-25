
defmodule DiscTree do

  # Parse a line
  def parse_line(line) do
    line_format = ~r/([a-z]+) \((\d+)\)( -> (.*))?/
    [_line, name, weight | maybe_children] = Regex.run(line_format, line)
    children = get_children(maybe_children)
    {name, weight, children}
  end

  # Parse the children that possibly exist in the line
  def get_children([]), do: []

  def get_children([_, children]) do
    children
      |> String.split(",")
      |> Enum.map(&String.trim/1)
  end

  def build_tree(lines, nodes \\ %{}, orphans \\ %{})

  def build_tree([], tree, orphans), do: remove_orphans tree, orphans

  def build_tree([line | lines], nodes, orphans) do
    {name, weight, children} = parse_line line
    nodes = Map.put(nodes, name, {weight, children})
    orphans = Map.put(orphans, name, :true)
    build_tree lines, nodes, orphans
  end

  def remove_orphans(tree, orphans) do
    all_children = Enum.flat_map(tree, fn {_, {_, orphans}} -> orphans end)
    [root] = orphans
      |> Map.drop(all_children)
      |> Map.keys
    root
  end

end

"tknk" = "day7-example.txt"
  |> File.stream!
  |> Enum.to_list
  |> DiscTree.build_tree


tree_root = "day7-input.txt"
  |> File.stream!
  |> Enum.to_list
  |> DiscTree.build_tree

IO.puts "Tree root is #{tree_root}"
