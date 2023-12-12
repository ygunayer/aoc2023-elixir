defmodule Aoc2023.Day10 do
  def parse_grid!(input) do
    cells =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {cell, x} ->
          type = type_of(cell)

          neighbors =
            cell
            |> neighbors_of()
            |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)

          {{x, y}, {cell, type, neighbors}}
        end)
      end)
      |> Enum.filter(fn {_pos, {cell, _type, _neighbors}} -> cell != "." end)
      |> Map.new()

    cells
    |> Enum.map(fn {{x, y}, {cell, type, neighbors}} ->
      actual_neighbors =
        Enum.filter(neighbors, fn {nx, ny} ->
          case Map.get(cells, {nx, ny}) do
            nil -> false
            {_nsymbol, ntype, _npos} -> can_connect(type, ntype)
          end
        end)

      {{x, y}, {cell, type, actual_neighbors}}
    end)
    |> Map.new()
    |> fix_start()
  end

  def fix_start(grid) do
    {{x, y}, {_, _, neighbors}} =
      grid
      |> Enum.find(fn
        {_, {_, :start, _}} -> true
        _ -> false
      end)

    actual_neighbors =
      neighbors
      |> Enum.filter(fn {nx, ny} ->
        {_, _, neighbors_neighbors} = Map.get(grid, {nx, ny})
        {x, y} in neighbors_neighbors
      end)

    actual_symbol =
      cond do
        {x - 1, y} in actual_neighbors and {x + 1, y} in actual_neighbors -> "-"
        {x, y - 1} in actual_neighbors and {x, y + 1} in actual_neighbors -> "|"
        {x, y - 1} in actual_neighbors and {x + 1, y} in actual_neighbors -> "L"
        {x, y + 1} in actual_neighbors and {x + 1, y} in actual_neighbors -> "F"
        {x, y - 1} in actual_neighbors and {x - 1, y} in actual_neighbors -> "J"
        {x, y + 1} in actual_neighbors and {x - 1, y} in actual_neighbors -> "7"
      end

    updated_grid =
      Map.put(grid, {x, y}, {actual_symbol, type_of(actual_symbol), actual_neighbors})

    {updated_grid, {x, y}}
  end

  def find_main_loop(grid, start_pos) do
    {_, _, [first_neighbor | _]} = Map.get(grid, start_pos)

    path =
      {start_pos, first_neighbor}
      |> Stream.iterate(fn {prev_pos, curr_pos} ->
        {_nsymbol, _ntype, [n1, n2]} = Map.get(grid, curr_pos)
        next_pos = if prev_pos == n1, do: n2, else: n1
        {curr_pos, next_pos}
      end)
      |> Enum.take_while(fn {_prev, curr} -> curr != start_pos end)
      |> Enum.to_list()
      |> Enum.map(fn {_prev, curr} -> curr end)

    [start_pos | path]
  end

  def type_of("|"), do: :vertical
  def type_of("-"), do: :horizontal
  def type_of("F"), do: :corner_top
  def type_of("7"), do: :corner_top
  def type_of("J"), do: :corner_bottom
  def type_of("L"), do: :corner_bottom
  def type_of("S"), do: :start
  def type_of("."), do: nil

  def neighbors_of("|"), do: [{0, 1}, {0, -1}]
  def neighbors_of("-"), do: [{-1, 0}, {1, 0}]
  def neighbors_of("L"), do: [{0, -1}, {1, 0}]
  def neighbors_of("J"), do: [{0, -1}, {-1, 0}]
  def neighbors_of("7"), do: [{0, 1}, {-1, 0}]
  def neighbors_of("F"), do: [{0, 1}, {1, 0}]
  def neighbors_of("S"), do: neighbors_of("|") ++ neighbors_of("-")
  def neighbors_of(_), do: []

  def can_connect(:horizontal, :vertical), do: false
  def can_connect(:vertical, :horizontal), do: false
  def can_connect(_, _), do: true

  def is_crossing?("L"), do: true
  def is_crossing?("J"), do: true
  def is_crossing?("|"), do: true
  def is_crossing?(_), do: false

  def find_enclosed_cells(grid, path) do
    path_points = MapSet.new(path)

    crossings =
      path
      |> Enum.filter(fn pos ->
        {_symbol, type, _neighbors} = Map.get(grid, pos)
        type == :corner_bottom || type == :vertical
      end)
      |> MapSet.new()

    {{min_x, _}, {max_x, _}} = Enum.min_max_by(path, fn {x, _y} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(path, fn {_x, y} -> y end)

    enclosed_cells =
      Enum.flat_map(min_y..max_y, fn y ->
        {_, cells_this_row} =
          min_x..max_x
          |> Enum.reduce({true, []}, fn x, {outside, cells_now} ->
            cond do
              MapSet.member?(crossings, {x, y}) ->
                {!outside, cells_now}

              MapSet.member?(path_points, {x, y}) ->
                {outside, cells_now}

              outside ->
                {true, cells_now}

              true ->
                {false, cells_now ++ [{x, y}]}
            end
          end)

        cells_this_row
      end)

    enclosed_cells
  end

  def show_grid(input, grid, loop, enclosed) do
    empty_grid =
      String.split(input, "\n", trim: true)
      |> Enum.map(fn row ->
        Enum.map(String.graphemes(row), fn _ -> "." end)
      end)

    grid_with_loop =
      loop
      |> Enum.reduce(empty_grid, fn {x, y}, acc ->
        {symbol, _, _} = Map.get(grid, {x, y})

        List.update_at(acc, y, fn row ->
          List.update_at(row, x, fn _ ->
            case symbol do
              "L" -> "└"
              "J" -> "┘"
              "7" -> "┐"
              "F" -> "┌"
              "S" -> "S"
              _ -> symbol
            end
          end)
        end)
      end)

    final_grid =
      enclosed
      |> Enum.reduce(grid_with_loop, fn {x, y}, acc ->
        List.update_at(acc, y, fn row ->
          List.update_at(row, x, fn _ -> "I" end)
        end)
      end)

    IO.puts("\n\n")

    final_grid
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()

    IO.puts("\n\n")
  end

  defmodule Part1 do
    def solve(input) do
      {grid, start_pos} = Aoc2023.Day10.parse_grid!(input)
      loop = Aoc2023.Day10.find_main_loop(grid, start_pos)
      ceil(Enum.count(loop) / 2)
    end
  end

  defmodule Part2 do
    def solve(input) do
      {grid, start_pos} = Aoc2023.Day10.parse_grid!(input)

      main_loop = Aoc2023.Day10.find_main_loop(grid, start_pos)
      enclosed = Aoc2023.Day10.find_enclosed_cells(grid, main_loop)

      Aoc2023.Day10.show_grid(input, grid, main_loop, enclosed)

      length(enclosed)
    end
  end
end
