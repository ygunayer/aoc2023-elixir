defmodule Aoc2023.Day09 do
  def parse_histories!(input),
    do: input |> String.split("\n", trim: true) |> Enum.map(&Aoc2023.parse_numbers!/1)

  def find_differences(numbers) do
    {diffs, all_zero} =
      2..Enum.count(numbers)
      |> Enum.reduce({[], false}, fn idx, {diffs, all_zero} ->
        diff = Enum.at(numbers, idx - 1) - Enum.at(numbers, idx - 2)
        {diffs ++ [diff], all_zero || diff != 0}
      end)

    if all_zero, do: [diffs] ++ find_differences(diffs), else: [diffs]
  end

  def sum_next_values(history) do
    [history | find_differences(history)]
    |> Enum.map(&Enum.at(&1, -1))
    |> Enum.sum()
  end

  defmodule Part1 do
    def solve(input) do
      input
      |> Aoc2023.Day09.parse_histories!()
      |> Enum.map(&Aoc2023.Day09.sum_next_values/1)
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    def solve(input) do
      input
      |> Aoc2023.Day09.parse_histories!()
      |> Enum.map(&Enum.reverse/1)
      |> Enum.map(&Aoc2023.Day09.sum_next_values/1)
      |> Enum.sum()
    end
  end
end
