defmodule Aoc2023.Day06 do
  def parse_races!(input) do
    [
      "Time:" <> times,
      "Distance:" <> distances
    ] = String.split(input, "\n", trim: true)

    Enum.zip(
      Aoc2023.parse_numbers!(times),
      Aoc2023.parse_numbers!(distances)
    )
  end

  def count_winning_numbers({time, record}) do
    1..(time - 1)
    |> Stream.map(fn k -> (time - k) * k end)
    |> Stream.filter(fn distance -> distance > record end)
    |> Enum.count()
  end

  defmodule Part1 do
    def solve(input) do
      input
      |> Aoc2023.Day06.parse_races!()
      |> Enum.map(&Aoc2023.Day06.count_winning_numbers/1)
      |> Enum.product()
    end
  end

  defmodule Part2 do
    def solve(input) do
      input
      |> String.replace(" ", "")
      |> Aoc2023.Day06.parse_races!()
      |> Enum.map(&Aoc2023.Day06.count_winning_numbers/1)
      |> Enum.product()
    end
  end
end
