defmodule Aoc2023.Day02 do
  @game_id_pattern ~r/Game\s+(\d+):/
  @color_value_pattern ~r/(\d+)\s+(\w+)/

  def parse_games!(input) do
    input
    |> Aoc2023.read_lines()
    |> Aoc2023.remove_blanks()
    |> Enum.map(&parse_game!/1)
  end

  def parse_round!(round) do
    Regex.scan(@color_value_pattern, round)
    |> Enum.reduce(%{}, fn [_, count, color], acc ->
      Map.put(acc, color, Map.get(acc, color, 0) + String.to_integer(count))
    end)
  end

  def parse_game!(line) do
    case Regex.run(@game_id_pattern, line) do
      [full_match, id] ->
        {_, all_rounds} = String.split_at(line, String.length(full_match))

        rounds =
          all_rounds
          |> String.split(";")
          |> Enum.map(&String.trim/1)
          |> Enum.filter(&Aoc2023.is_non_blank?/1)
          |> Enum.map(&parse_round!/1)

        {String.to_integer(id), rounds}

      _ ->
        raise ArgumentError, message: "Invalid game pattern: #{line}"
    end
  end

  def is_game_possible?({_, rounds}, bag) do
    Enum.all?(bag, fn {color, count} ->
      Enum.all?(rounds, fn round ->
        Map.get(round, color, 0) <= count
      end)
    end)
  end

  def game_min_requirements({_, rounds}) do
    rounds
    |> Enum.flat_map(fn round -> Map.to_list(round) end)
    |> Enum.reduce(%{}, fn {color, count}, acc ->
      # worst hack ever
      Map.update(acc, color, count, fn c -> max(count, c) end)
    end)
  end

  def power_of_min_requirements(game) do
    game
    |> game_min_requirements()
    |> Enum.reduce(1, fn {_color, count}, acc -> count * acc end)
  end

  defmodule Part1 do
    def solve(input) do
      input
      |> Aoc2023.read_lines()
      |> Aoc2023.remove_blanks()
      |> Enum.map(&Aoc2023.Day02.parse_game!/1)
      |> Enum.filter(
        &Aoc2023.Day02.is_game_possible?(&1, %{"red" => 12, "green" => 13, "blue" => 14})
      )
      |> Enum.reduce(0, fn {id, _}, acc -> acc + id end)
    end
  end

  defmodule Part2 do
    def solve(input) do
      input
      |> Aoc2023.read_lines()
      |> Aoc2023.remove_blanks()
      |> Enum.map(&Aoc2023.Day02.parse_game!/1)
      |> Enum.map(&Aoc2023.Day02.power_of_min_requirements/1)
      |> Enum.reduce(0, fn power, acc -> power + acc end)
    end
  end
end
