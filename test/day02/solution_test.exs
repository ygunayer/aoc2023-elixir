defmodule Aoc2023.Day02Test do
  use ExUnit.Case

  alias Aoc2023.Day02.Part1
  alias Aoc2023.Day02.Part2

  @test_input1 File.read!("test/day02/input1.txt")
  @test_input2 File.read!("test/day02/input2.txt")

  describe "Day02" do
    test "Part1" do
      assert 8 == @test_input1 |> Part1.solve()
    end

    test "Part2" do
      assert 2286 == @test_input2 |> Part2.solve()
    end
  end
end
