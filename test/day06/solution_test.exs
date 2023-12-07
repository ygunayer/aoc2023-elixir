defmodule Aoc2023.Day06Test do
  use ExUnit.Case

  alias Aoc2023.Day06.Part1
  alias Aoc2023.Day06.Part2

  @test_input1 File.read!("test/day06/input1.txt")
  @test_input2 File.read!("test/day06/input2.txt")

  describe "Day06" do
    test "Part1" do
      assert 288 == @test_input1 |> Part1.solve()
    end

    test "Part2" do
      assert 71503 == @test_input2 |> Part2.solve()
    end
  end
end
