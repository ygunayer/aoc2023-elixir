defmodule Mix.TaskHelper do
  def dirs_by_day() do
    1..31
    |> Enum.map(&leftpad/1)
    |> Enum.map(&dirs_for/1)
  end

  def first_unimplemented_day() do
    dirs_by_day()
    |> Enum.drop_while(&day_exists?/1)
    |> Enum.take(1)
    |> Enum.at(0)
  end

  def last_implemented_day() do
    dirs_by_day()
    |> Enum.take_while(&day_exists?/1)
    |> List.last()
  end

  def dirs_for(day), do: {day |> leftpad(), lib_dir_for(day), test_dir_for(day)}

  def lib_dir_for(day), do: Path.join(["lib", "day" <> leftpad(day)])

  def test_dir_for(day), do: Path.join(["test", "day" <> leftpad(day)])

  def day_exists?({_, lib_dir, _}), do: lib_dir |> File.exists?()

  def leftpad(input, len \\ 2), do: input |> to_string() |> String.pad_leading(len, "0")

  def mkdir(path) do
    unless File.exists?(path) do
      File.mkdir!(path)
    end
  end
end
