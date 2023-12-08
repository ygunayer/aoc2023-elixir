defmodule Aoc2023.Day07Test do
  use ExUnit.Case

  alias Aoc2023.Day07.Part1
  alias Aoc2023.Day07.Part2

  @test_input1 File.read!("test/day07/input1.txt")
  @test_input2 File.read!("test/day07/input2.txt")

  describe "Day07" do
    @comparison_cases [
      # left, right, left > right
      {"32T3K", "T55J5", false},
      {"KK677", "KTJJT", true},
      {"T55J5", "QQQJA", false},
      {"AAAAA", "KKKKK", true},
      {"22222", "JJJJJ", false},
      {"AAAA1", "KKKKK", false}
    ]

    for {left, right, expected} <- @comparison_cases do
      test "compare_hands #{inspect(left)} <> #{inspect(right)} should return #{expected}" do
        left_hand = Aoc2023.Day07.parse_hand!(unquote(left))
        right_hand = Aoc2023.Day07.parse_hand!(unquote(right))
        assert Aoc2023.Day07.compare_hands(left_hand, right_hand, false) == unquote(expected)
      end
    end

    test "Part1" do
      assert 6440 == @test_input1 |> Part1.solve()
    end

    test "Part2" do
      assert 5905 == @test_input2 |> Part2.solve()
    end
  end
end
