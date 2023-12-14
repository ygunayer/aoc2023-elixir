defmodule Aoc2023 do
  @number_pattern ~r/(\-?\d+)/

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

  def parse_numbers!(input) do
    @number_pattern
    |> Regex.scan(input)
    |> Enum.map(fn [_, num] -> String.to_integer(num) end)
  end

  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))

  def permutations([], _), do: [[]]
  def permutations(_, 0), do: [[]]

  def permutations(list, n) do
    for head <- list, tail <- permutations(list, n - 1) do
      [head | tail]
    end
  end
end
