defmodule Aoc2023.Day04 do
  @card_id_pattern ~r/Card\s+(\d+)/
  @number_pattern ~r/(\d+)/

  def parse_numbers!(numbers) do
    @number_pattern
    |> Regex.scan(numbers)
    |> Enum.map(fn
      [_, num] -> String.to_integer(num)
      _ -> raise ArgumentError, message: "Failed to find numbers in string #{numbers}"
    end)
  end

  def parse_card!(line) do
    case Regex.run(@card_id_pattern, line) do
      [id_match, id] ->
        {_, all_numbers} = String.split_at(line, String.length(id_match))
        [left, right] = String.split(all_numbers, " | ")

        winning_numbers = parse_numbers!(left)
        my_numbers = parse_numbers!(right)

        {id, winning_numbers, my_numbers}

      _ ->
        raise ArgumentError, message: "Invalid card line #{line}"
    end
  end

  def get_winning_numbers({_, winning, mine}) do
    mine
    |> Enum.filter(fn num -> num in winning end)
  end

  def get_card_score(card) do
    case get_winning_numbers(card) do
      [] -> 0
      numbers -> 2 ** (Enum.count(numbers) - 1)
    end
  end

  def count_with_copies(cards) do
    cards_with_copies =
      cards
      |> Enum.map(fn {card_id, _, _} = card ->
        {String.to_integer(card_id), card |> Aoc2023.Day04.get_winning_numbers() |> Enum.count()}
      end)

    cards_with_copies
    |> Enum.reduce(0, fn {card_id, num_copies}, acc ->
      acc + count_with_copies(cards_with_copies, {card_id, num_copies})
    end)
  end

  defp count_with_copies(_cards, {_card_id, 0}), do: 1

  defp count_with_copies(cards, {card_id, num_copies}) do
    Range.to_list(1..num_copies)
    |> Enum.reduce(1, fn copy_idx, acc ->
      card_idx = card_id + copy_idx - 1

      case Enum.at(cards, card_idx) do
        nil -> acc
        c -> acc + count_with_copies(cards, c)
      end
    end)
  end

  defmodule Part1 do
    def solve(input) do
      input
      |> Aoc2023.read_lines()
      |> Aoc2023.remove_blanks()
      |> Enum.map(&Aoc2023.Day04.parse_card!/1)
      |> Enum.map(&Aoc2023.Day04.get_card_score/1)
      |> Enum.reduce(0, &(&1 + &2))
    end
  end

  defmodule Part2 do
    def solve(input) do
      input
      |> Aoc2023.read_lines()
      |> Aoc2023.remove_blanks()
      |> Enum.map(&Aoc2023.Day04.parse_card!/1)
      |> Aoc2023.Day04.count_with_copies()
    end
  end
end
