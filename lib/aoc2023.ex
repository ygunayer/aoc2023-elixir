defmodule Aoc2023 do
  def read_lines(input), do: input |> read_lines(false) |> Enum.map(&String.trim/1)
  def read_lines(input, false), do: input |> String.split(~r/\n/)

  def remove_blanks(lines), do: lines |> Enum.filter(&is_non_blank?/1)

  def is_non_blank?(""), do: false
  def is_non_blank?(x) when is_binary(x), do: true

  def parse_int!(str) do
    case Integer.parse(str) do
      :error -> raise "Invalid number #{str}"
      {num, _} -> num
    end
  end
end
