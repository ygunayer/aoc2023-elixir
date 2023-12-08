defmodule Aoc2023.Day08 do
  def parse_network(input) do
    [path | unparsed_nodes] = String.split(input, ~r/\n+/, trim: true)

    nodes =
      unparsed_nodes
      |> Enum.map(fn line ->
        [node, left, right] = String.split(line, ~r/[^\w]+/, trim: true)
        {node, {node, {left, right}}}
      end)
      |> Map.new()

    {String.graphemes(path), nodes}
  end

  def traverse({path, nodes}, start_from, should_stop) do
    path
    |> Stream.cycle()
    |> Enum.reduce_while({start_from, 1}, fn direction, {{_, {left, right}}, steps} ->
      next_node_name = if direction == "L", do: left, else: right

      if should_stop.(next_node_name) do
        {:halt, steps}
      else
        {:cont, {nodes[next_node_name], steps + 1}}
      end
    end)
  end

  defmodule Part1 do
    def solve(input) do
      {path, nodes} = Aoc2023.Day08.parse_network(input)
      Aoc2023.Day08.traverse({path, nodes}, Map.get(nodes, "AAA"), &(&1 == "ZZZ"))
    end
  end

  defmodule Part2 do
    def solve(input) do
      {path, nodes} = Aoc2023.Day08.parse_network(input)

      nodes
      |> Enum.filter(fn {k, _} -> String.ends_with?(k, "A") end)
      |> Enum.map(fn {_, node} ->
        Aoc2023.Day08.traverse({path, nodes}, node, &String.ends_with?(&1, "Z"))
      end)
      |> Enum.reduce(&Aoc2023.lcm/2)
    end
  end
end
