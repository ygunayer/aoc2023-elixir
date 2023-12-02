defmodule Aoc2023.Day01Test do
  use ExUnit.Case

  alias Aoc2023.Day01.Part1
  alias Aoc2023.Day01.Part2

  @test_input File.read!("test/day01/input1.txt")
  @test_input2 File.read!("test/day01/input2.txt")

  describe "Day01" do
    test "Part1" do
      assert 142 == @test_input |> Part1.solve()
    end

    test "Part2" do
      assert 281 == @test_input2 |> Part2.solve()
    end
  end
end
