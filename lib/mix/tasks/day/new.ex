defmodule Mix.Tasks.Day.New do
  alias Mix.TaskHelper

  def run(args) do
    {padded_day, lib_dir, test_dir} = parse_args(args)
    {raw_day, _} = Integer.parse(padded_day)

    lib_dir |> TaskHelper.mkdir()
    Path.join([lib_dir, "solution.ex"]) |> File.write!(render_solution_file(padded_day))
    Path.join([lib_dir, "input.txt"]) |> File.write!("")

    test_dir |> TaskHelper.mkdir()
    Path.join([test_dir, "solution_test.exs"]) |> File.write!(render_test_file(padded_day))
    Path.join([test_dir, "input1.txt"]) |> File.write!("")
    Path.join([test_dir, "input2.txt"]) |> File.write!("")

    IO.puts("Generated files for day #{padded_day}")
    IO.puts("Instructions: https://adventofcode.com/2022/day/#{raw_day}")
    IO.puts("Input: https://adventofcode.com/2022/day/#{raw_day}/input")
  end

  def parse_args([day]), do: TaskHelper.dirs_for(day)
  def parse_args([]), do: TaskHelper.first_unimplemented_day()

  defp render_solution_file(day) do
    """
    defmodule Aoc2023.Day#{day} do
      defmodule Part1 do
        def solve(input) do
          raise "Not implemented yet"
        end
      end

      defmodule Part2 do
        def solve(input) do
          raise "Not implemented yet"
        end
      end
    end
    """
  end

  defp render_test_file(day) do
    """
    defmodule Aoc2023.Day#{day}Test do
      use ExUnit.Case

      alias Aoc2023.Day#{day}.Part1
      alias Aoc2023.Day#{day}.Part2

      @test_input1 File.read!("test/day#{day}/input1.txt")
      @test_input2 File.read!("test/day#{day}/input2.txt")

      describe "Day#{day}" do
        test "Part1" do
          assert 42 == @test_input1 |> Part1.solve()
        end

        test "Part2" do
          assert 42 == @test_input2 |> Part2.solve()
        end
      end
    end
    """
  end
end
