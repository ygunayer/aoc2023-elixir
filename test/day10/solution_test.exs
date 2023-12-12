defmodule Aoc2023.Day10Test do
  use ExUnit.Case

  alias Aoc2023.Day10.Part1
  alias Aoc2023.Day10.Part2

  @test_input1 File.read!("test/day10/input1.txt")
  @test_input2 File.read!("test/day10/input2.txt")
  @test_input3 File.read!("test/day10/input3.txt")
  @test_input4 File.read!("test/day10/input4.txt")
  @test_input5 File.read!("test/day10/input5.txt")

  describe "Day10" do
    test "Part1" do
      assert 4 == @test_input1 |> Part1.solve()
      assert 8 == @test_input2 |> Part1.solve()
    end

    test "Part2" do
      assert 1 == @test_input1 |> Part2.solve()
      assert 1 == @test_input2 |> Part2.solve()
      assert 4 == @test_input3 |> Part2.solve()
      assert 8 == @test_input4 |> Part2.solve()
      assert 10 == @test_input5 |> Part2.solve()
    end
  end
end
