defmodule Mix.Tasks.Day.Solve do
  use Mix.Task

  alias Mix.TaskHelper

  def run(args) do
    {day, parts} = args |> parse_args()

    {padded_day, _, _} = day

    parts
    |> Enum.each(fn part ->
      input = read_input!(day, part)

      result =
        Module.concat([
          Aoc2023,
          "Day#{padded_day}",
          "Part#{part}"
        ])
        |> apply(:solve, [input])

      IO.puts("Day: #{padded_day}, Part: #{part}")
      IO.puts("--------")
      IO.puts(inspect(result))
      IO.puts("")
    end)
  end

  def parse_args([day]), do: {TaskHelper.dirs_for(day), ["1", "2"]}
  def parse_args([day, part]), do: {TaskHelper.dirs_for(day), [part]}
  def parse_args([]), do: {TaskHelper.last_implemented_day(), ["1", "2"]}

  def read_input!({_, lib_dir, _}, part) do
    part_file = Path.join(lib_dir, "input" <> part <> ".txt")
    common_file = Path.join(lib_dir, "input.txt")

    [part_file, common_file]
    |> Enum.filter(&File.exists?/1)
    |> Enum.at(0)
    |> File.read!()
  end
end
