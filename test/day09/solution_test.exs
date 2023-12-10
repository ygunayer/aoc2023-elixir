defmodule Aoc2023.Day09Test do
  use ExUnit.Case

  alias Aoc2023.Day09.Part1
  alias Aoc2023.Day09.Part2

  @test_input1 File.read!("test/day09/input1.txt")
  @test_input2 File.read!("test/day09/input2.txt")

  describe "Day09" do
    test "Part1" do
      assert 114 == @test_input1 |> Part1.solve()
    end

    test "Part2" do
      assert 2 == @test_input2 |> Part2.solve()
    end
  end
end
