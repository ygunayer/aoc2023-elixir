defmodule Aoc2023.Day11Test do
  use ExUnit.Case

  alias Aoc2023.Day11.Part1
  alias Aoc2023.Day11.Part2

  @test_input1 File.read!("test/day11/input1.txt")
  @test_input2 File.read!("test/day11/input2.txt")

  describe "Day11" do
    test "Part1" do
      assert 374 == @test_input1 |> Part1.solve()
    end

    test "Part2" do
      assert 42 == @test_input2 |> Part2.solve()
    end
  end
end
