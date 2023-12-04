defmodule Aoc2023.Day03Test do
  use ExUnit.Case

  alias Aoc2023.Day03.Part1
  alias Aoc2023.Day03.Part2

  @test_input1 File.read!("test/day03/input1.txt")
  @test_input2 File.read!("test/day03/input2.txt")

  describe "Day03" do
    test "Part1" do
      assert 4361 == @test_input1 |> Part1.solve()
    end

    test "Part2" do
      assert 467_835 == @test_input2 |> Part2.solve()
    end
  end
end
