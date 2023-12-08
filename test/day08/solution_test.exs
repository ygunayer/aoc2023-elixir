defmodule Aoc2023.Day08Test do
  use ExUnit.Case

  alias Aoc2023.Day08.Part1
  alias Aoc2023.Day08.Part2

  @test_input1 File.read!("test/day08/input1.txt")
  @test_input2 File.read!("test/day08/input2.txt")
  @test_input3 File.read!("test/day08/input3.txt")

  describe "Day08" do
    test "Part1" do
      assert 2 == @test_input1 |> Part1.solve()
      assert 6 == @test_input2 |> Part1.solve()
    end

    test "Part2" do
      # assert 2 == @test_input1 |> Part2.solve()
      # assert 6 == @test_input2 |> Part2.solve()
      assert 6 == @test_input3 |> Part2.solve()
    end
  end
end
