defmodule Aoc2023.Day08 do
  def parse_network(input) do
    [path | unparsed_nodes] = String.split(input, ~r/\n+/, trim: true)

    nodes =
      unparsed_nodes
      |> Enum.map(fn line ->
        [node, left, right] = String.split(line, ~r/[^\w]+/, trim: true)
        {node, {left, right}}
      end)
      |> Map.new()

    {String.graphemes(path), nodes}
  end

  def traverse_aaa_to_zzz({path, nodes}) do
    path
    |> Stream.cycle()
    |> Enum.reduce_while({nodes["AAA"], 1}, fn direction, {{left, right}, steps} ->
      next_node_name = if direction == "L", do: left, else: right

      case next_node_name do
        "ZZZ" -> {:halt, steps}
        _ -> {:cont, {nodes[next_node_name], steps + 1}}
      end
    end)
  end

  defmodule Part1 do
    def solve(input) do
      input
      |> Aoc2023.Day08.parse_network()
      |> Aoc2023.Day08.traverse_aaa_to_zzz()
    end
  end

  defmodule Part2 do
    def solve(input) do
      raise "Not implemented yet"
    end
  end
end
