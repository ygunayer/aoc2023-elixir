defmodule Aoc2023.Day11 do
  def parse_universe!(input) do
    grid = Grid.parse!(input)

    empty_rows =
      grid
      |> Grid.rows()
      |> Enum.with_index()
      |> Enum.filter(fn {row, _y} -> Enum.all?(row, &is_empty_cell?/1) end)
      |> Enum.map(fn {_row, y} -> y end)
      |> MapSet.new()

    empty_cols =
      grid
      |> Grid.cols()
      |> Enum.with_index()
      |> Enum.filter(fn {col, _x} -> Enum.all?(col, &is_empty_cell?/1) end)
      |> Enum.map(fn {_row, x} -> x end)
      |> MapSet.new()

    galaxies =
      grid
      |> Grid.with_positions()
      |> Grid.rows()
      |> Enum.flat_map(fn row ->
        row
        |> Enum.filter(fn {_pos, cell} -> !is_empty_cell?(cell) end)
        |> Enum.map(fn {pos, _cell} -> pos end)
      end)

    {grid, galaxies, empty_rows, empty_cols}
  end

  def is_empty_cell?("."), do: true
  def is_empty_cell?(nil), do: true
  def is_empty_cell?(_), do: false

  def manhattan_distance({x0, y0}, {x1, y1}) do
    abs(x0 - x1) + abs(y0 - y1)
  end

  def distance({x0, y0}, {x1, y1}, empty_rows, empty_cols, scale \\ 2) do
    base_distance = Aoc2023.Day11.manhattan_distance({x0, y0}, {x1, y1})
    num_empty_rows = Enum.count(y0..y1, &MapSet.member?(empty_rows, &1))
    num_empty_cols = Enum.count(x0..x1, &MapSet.member?(empty_cols, &1))

    base_distance + (num_empty_cols + num_empty_rows) * (scale - 1)
  end

  def solve(input, expansion_scale) do
    {_universe, galaxies, empty_rows, empty_cols} = Aoc2023.Day11.parse_universe!(input)

    galaxies
    |> Aoc2023.permutations(2)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> Enum.filter(fn [p0, p1] -> p0 != p1 end)
    |> Enum.map(fn [p0, p1] ->
      Aoc2023.Day11.distance(p0, p1, empty_rows, empty_cols, expansion_scale)
    end)
    |> Enum.sum()
  end

  defmodule Part1 do
    def solve(input), do: Aoc2023.Day11.solve(input, 2)
  end

  defmodule Part2 do
    def solve(input), do: Aoc2023.Day11.solve(input, 1_000_000)
  end
end
