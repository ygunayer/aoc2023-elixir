defmodule Grid do
  defstruct [:rows, :width, :height]

  @moduledoc """
  A 2-dimensional grid optimized for row-based read access.
  """

  @type position() :: {integer(), integer()}
  @type value() :: String.t()
  @type rows() :: [[value()]]
  @type width() :: integer()
  @type height() :: integer()
  @type t() :: %__MODULE__{rows: rows(), width: width(), height: height()}

  @spec parse!(binary()) :: Grid.t() | no_return()
  def parse!(input) do
    {rows, width, height} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], 0, 0}, fn row, {rows, width, height} ->
        cells = String.graphemes(row)
        row_width = length(cells)
        {rows ++ [cells], max(width, row_width), height + 1}
      end)

    %__MODULE__{rows: rows, width: width, height: height}
  end

  @spec with_positions(Grid.t()) :: Grid.t()
  def with_positions(%__MODULE__{rows: rows} = grid) do
    new_rows =
      rows
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {cell, x} ->
          {{x, y}, cell}
        end)
      end)

    %__MODULE__{grid | rows: new_rows}
  end

  @spec row(Grid.t(), integer()) :: [value()] | nil
  def row(%__MODULE__{rows: rows}, idx), do: Enum.at(rows, idx)

  @spec col(Grid.t(), integer()) :: [value()] | nil
  def col(%__MODULE__{rows: rows}, idx), do: Enum.map(rows, fn row -> Enum.at(row, idx) end)

  @spec cell(Grid.t(), position()) :: value() | nil
  def cell(%__MODULE__{rows: rows}, {x, y}) do
    case Enum.at(rows, y) do
      nil -> nil
      row -> Enum.at(row, x)
    end
  end

  @spec rows(Grid.t()) :: [[value()]]
  def rows(%__MODULE__{rows: rows}), do: rows

  @spec cols(Grid.t()) :: [[value()]]
  def cols(%__MODULE__{rows: rows, width: width, height: height}) do
    0..(width - 1)
    |> Enum.map(fn x ->
      0..(height - 1)
      |> Enum.map(fn y ->
        case Enum.at(rows, y) do
          nil -> nil
          row -> Enum.at(row, x)
        end
      end)
    end)
  end

  @spec replace_all(Grid.t(), value()) :: Grid.t()
  def replace_all(%__MODULE__{rows: rows} = grid, value) do
    new_rows = Enum.map(rows, fn row -> Enum.map(row, fn _ -> value end) end)
    %__MODULE__{grid | rows: new_rows}
  end

  @spec replace(Grid.t(), position(), value()) :: Grid.t()
  def replace(%__MODULE__{width: width, height: height} = grid, {x, y}, _value)
      when x < 0 or x >= width or y < 0 or y >= height,
      do: grid

  def replace(%__MODULE__{rows: rows} = grid, {x, y}, value) do
    new_rows =
      rows
      |> List.update_at(y, fn row ->
        List.update_at(row, x, fn _ -> value end)
      end)

    %__MODULE__{grid | rows: new_rows}
  end

  def insert_row(%__MODULE__{rows: rows, height: height} = grid, at, row) do
    new_rows = List.insert_at(rows, at, row)
    %__MODULE__{grid | rows: new_rows, height: height + 1}
  end

  def insert_col(%__MODULE__{rows: rows, height: height, width: width} = grid, at, col) do
    new_rows =
      0..height
      |> Enum.map(fn y ->
        rows
        |> Enum.at(y)
        |> List.insert_at(at, Enum.at(col, y))
      end)

    %__MODULE__{grid | rows: new_rows, width: width + 1}
  end

  @spec display(Grid.t()) :: no_return()
  def display(%__MODULE__{rows: rows}) do
    rows
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn
        {_pos, value} -> value
        value -> value
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
