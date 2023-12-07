defmodule Aoc2023.Day05Test do
  use ExUnit.Case

  alias Aoc2023.Day05
  alias Aoc2023.Day05.Part1
  alias Aoc2023.Day05.Part2

  @test_input1 File.read!("test/day05/input1.txt")
  @test_input2 File.read!("test/day05/input2.txt")

  describe "Day05" do
    test "should cut seed ranges properly" do
      assert {[4..4, 8..8], [2..4]} == Day05.cut_seed_range_into_map_range(4..8, {5..7, -3})
      assert {[], [23..24]} == Day05.cut_seed_range_into_map_range(3..4, {1..7, 20})
      assert {[4..8], [12..13]} == Day05.cut_seed_range_into_map_range(2..8, {1..3, 10})
      assert {[2..5], [3..6]} == Day05.cut_seed_range_into_map_range(2..9, {6..11, -3})
      assert {[97..98], [56..59]} == Day05.cut_seed_range_into_map_range(93..98, {93..96, -37})
    end

    test "should run seed range through map properly" do
      seed_range = 90..98
      map = [{56..92, 4}, {93..96, -37}]
      assert [97..98, 56..59, 94..96] == Day05.run_seed_range_through_map(seed_range, map)
    end

    test "should run seed range through almanac properly" do
      %{maps: maps} = Day05.parse_almanac!(@test_input1)
      seed_range = 55..67

      one_by_one =
        seed_range
        |> Enum.map(&Day05.run_seed_through_almanac(&1, maps))
        |> Enum.sort()
        |> Enum.join(",")

      ranged =
        seed_range
        |> Day05.run_seed_range_through_almanac(maps)
        |> Enum.flat_map(&Range.to_list/1)
        |> Enum.sort()
        |> Enum.join(",")

      assert ranged == one_by_one
    end

    test "solve the same both one by one and also in range" do
      %{maps: maps} = Day05.parse_almanac!(@test_input1)
      seed_range = 55..67

      one_by_one =
        seed_range
        |> Enum.map(&Day05.run_seed_through_almanac(&1, maps))
        |> Enum.min()

      ranged =
        seed_range
        |> Day05.run_seed_range_through_almanac(maps)
        |> Enum.flat_map(&Range.to_list/1)
        |> Enum.min()

      assert ranged == one_by_one
    end

    test "Part1" do
      assert 35 == @test_input1 |> Part1.solve()
    end

    test "Part2" do
      assert 46 == @test_input2 |> Part2.solve()
    end
  end
end
