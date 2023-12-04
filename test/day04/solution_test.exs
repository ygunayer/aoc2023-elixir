defmodule Aoc2023.Day04Test do
  use ExUnit.Case

  alias Aoc2023.Day04.Part1
  alias Aoc2023.Day04.Part2

  @test_input1 File.read!("test/day04/input1.txt")
  @test_input2 File.read!("test/day04/input2.txt")

  describe "Day04" do
    test "Part1" do
      assert 13 == @test_input1 |> Part1.solve()
    end

    test "Part2" do
      assert 30 == @test_input2 |> Part2.solve()
    end
  end
end
