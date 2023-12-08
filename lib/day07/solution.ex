defmodule Aoc2023.Day07 do
  @bid_pattern ~r/([AKQJT98765432]{5})\s+(\d+)/

  def parse_bid!(input, use_joker \\ false) do
    [_, cards, bid_amount] = Regex.run(@bid_pattern, input)
    {parse_hand!(cards, use_joker), String.to_integer(bid_amount)}
  end

  def parse_bids!(input, use_joker \\ false) do
    input
    |> String.trim()
    |> Aoc2023.read_lines()
    |> Enum.map(&parse_bid!(&1, use_joker))
  end

  def card_value("J", true), do: 1
  def card_value("A", _), do: 14
  def card_value("K", _), do: 13
  def card_value("Q", _), do: 12
  def card_value("J", _), do: 11
  def card_value("T", _), do: 10
  def card_value(c, _), do: String.to_integer(c)

  def hand_rank(:five), do: 6
  def hand_rank(:four), do: 5
  def hand_rank(:full_house), do: 4
  def hand_rank(:three), do: 3
  def hand_rank(:two_pair), do: 2
  def hand_rank(:pair), do: 1
  def hand_rank(:high_card), do: 0

  def compare_cards([card1 | rest1], [card2 | rest2], use_jokers) do
    if card1 == card2 do
      compare_cards(rest1, rest2, use_jokers)
    else
      card_value(card1, use_jokers) > card_value(card2, use_jokers)
    end
  end

  def compare_cards([], [], _), do: false

  def compare_hands({t1, c1}, {t2, c2}, use_jokers) when t1 == t2,
    do: compare_cards(c1, c2, use_jokers)

  def compare_hands({t1, _}, {t2, _}, _), do: hand_rank(t1) > hand_rank(t2)

  def hand_type([{_, 5}]), do: :five
  def hand_type([{_, 4}, _]), do: :four
  def hand_type([{_, 3}, {_, 2}]), do: :full_house
  def hand_type([{_, 3} | _]), do: :three
  def hand_type([{_, 2}, {_, 2}, _]), do: :two_pair
  def hand_type([{_, 2} | _]), do: :pair
  def hand_type(_), do: :high_card

  def parse_hand!(hand, use_jokers \\ false) do
    cards =
      hand
      |> String.trim()
      |> String.graphemes()

    sorted_cards =
      cards
      |> Enum.frequencies()
      |> Enum.to_list()
      |> Enum.sort_by(fn {_card, count} -> count end, :desc)

    sorted_cards =
      if use_jokers do
        {joker, non_joker} =
          sorted_cards
          |> Enum.reduce({nil, []}, fn card, {joker, non_joker} ->
            case card do
              {"J", _} -> {card, non_joker}
              _ -> {joker, non_joker ++ [card]}
            end
          end)

        case {joker, non_joker} do
          {_, []} ->
            sorted_cards

          {nil, _} ->
            sorted_cards

          {{_, joker_count}, [{highest_card, highest_card_count} | rest]} ->
            [{highest_card, highest_card_count + joker_count}] ++ rest
        end
      else
        sorted_cards
      end

    type = hand_type(sorted_cards)

    {type, cards}
  end

  def sort_bids(bids, use_jokers \\ false) do
    Enum.sort(bids, fn {h1, _bid1}, {h2, _bid2} -> compare_hands(h1, h2, use_jokers) end)
  end

  defmodule Part1 do
    def solve(input) do
      sorted_bids =
        input
        |> Aoc2023.Day07.parse_bids!()
        |> Aoc2023.Day07.sort_bids()

      sorted_bids
      |> Enum.zip(Enum.count(sorted_bids)..1)
      |> Enum.map(fn {{_hand, bid}, rank} -> rank * bid end)
      |> Enum.sum()
    end
  end

  defmodule Part2 do
    def solve(input) do
      sorted_bids =
        input
        |> Aoc2023.Day07.parse_bids!(true)
        |> Aoc2023.Day07.sort_bids(true)

      sorted_bids
      |> Enum.zip(Enum.count(sorted_bids)..1)
      |> Enum.map(fn {{_hand, bid}, rank} -> rank * bid end)
      |> Enum.sum()
    end
  end
end
