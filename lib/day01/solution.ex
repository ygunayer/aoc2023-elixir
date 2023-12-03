defmodule Aoc2023.Day01 do
  @tokens %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9",
    "1" => "1",
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9"
  }

  def calibration_value!(val) do
    matched_tokens =
      Enum.reduce(@tokens, [], fn {token, value}, acc ->
        token_matches =
          val
          |> :binary.matches(token)
          |> Enum.map(fn {idx, _len} -> {idx, token, value} end)

        acc ++ token_matches
      end)
      |> Enum.sort_by(fn {idx, _token, _value} -> idx end)

    case matched_tokens do
      [] ->
        raise ArgumentError, message: "Invalid calibration input #{val}"

      _ ->
        {_, _, first_digit} = List.first(matched_tokens)
        {_, _, last_digit} = List.last(matched_tokens)
        String.to_integer(first_digit <> last_digit)
    end
  end

  def solve(input) do
    input
    |> Aoc2023.read_lines()
    |> Aoc2023.remove_blanks()
    |> Enum.map(&calibration_value!/1)
    |> Enum.reduce(&(&1 + &2))
  end

  defmodule Part1 do
    def solve(input), do: Aoc2023.Day01.solve(input)
  end

  defmodule Part2 do
    def solve(input), do: Aoc2023.Day01.solve(input)
  end
end
