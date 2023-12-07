defmodule Aoc2023.Day05 do
  @number_pattern ~r/(\d+)/

  def run_seed_through_map(seed, map) do
    map
    |> Stream.filter(fn {map_range, _delta} -> seed in map_range end)
    |> Stream.take(1)
    |> Stream.map(fn {_map_range, delta} -> seed + delta end)
    |> Enum.at(0) || seed
  end

  def run_seed_through_almanac(seed, maps) do
    Enum.reduce(maps, seed, &run_seed_through_map(&2, &1))
  end

  def cut_seed_range_into_map_range(%Range{} = seed_range, {%Range{} = map_range, delta}) do
    cond do
      # seed range is completely outside the map, use the seed range for the next iteration
      Range.disjoint?(seed_range, map_range) ->
        {[seed_range], []}

      seed_range.first == map_range.first && map_range.last == seed_range.first ->
        {[], Range.shift(seed_range, delta)}

      # seed range completely covers the map range on both ends, split the range into 3 parts
      # parts 1 and 3 are outside the map range need to be re-evaluated on the next run
      # part 2 is the map range itself and can be shifted by the map's delta value
      seed_range.first < map_range.first && map_range.last < seed_range.last ->
        pre_range = seed_range.first..(map_range.first - 1)
        post_range = (map_range.last + 1)..seed_range.last
        shifted_map_range = Range.shift(map_range, delta)
        {[pre_range, post_range], [shifted_map_range]}

      # seed range is completely covered by the map range on both ends
      # shift it by the map's delta value and mark it as handled
      map_range.first <= seed_range.first && seed_range.last <= map_range.last ->
        shifted_seed_range = Range.shift(seed_range, delta)
        {[], [shifted_seed_range]}

      # the map covers the left side of the seed range, but not the right side
      # shift the contained part and submit the remaining part for re-evaluation
      map_range.first <= seed_range.first ->
        shifted_seed_range = Range.shift(seed_range.first..map_range.last, delta)
        post_range = (map_range.last + 1)..seed_range.last
        {[post_range], [shifted_seed_range]}

      # the map covers the right side of the seed range, but not the left side
      # shift the contained part and submit the remaining part for re-evaluation
      seed_range.last <= map_range.last ->
        shifted_seed_range = Range.shift(map_range.first..seed_range.last, delta)
        pre_range = seed_range.first..(map_range.first - 1)
        {[pre_range], [shifted_seed_range]}

      true ->
        {[seed_range], []}
    end
  end

  def run_seed_range_through_map(seed_range, map) do
    {unprocessed, processed} =
      Enum.reduce(map, {[seed_range], []}, fn map_range, {unprocessed, processed} ->
        {new_unprocessed, new_processed} =
          unprocessed
          |> Enum.map(&cut_seed_range_into_map_range(&1, map_range))
          |> Enum.unzip()

        {List.flatten(new_unprocessed), List.flatten(new_processed) ++ processed}
      end)

    unprocessed ++ processed
  end

  def run_seed_range_through_almanac(seed_range, maps) do
    Enum.reduce(maps, [seed_range], fn map, current_ranges ->
      Enum.flat_map(current_ranges, &run_seed_range_through_map(&1, map))
    end)
  end

  def parse_almanac!(input) do
    [seeds_stmt | map_blocks] =
      input
      |> String.trim()
      |> String.split("\n\n")

    seeds = parse_seeds!(seeds_stmt)

    maps = Enum.map(map_blocks, &parse_map!/1)

    %{seeds: seeds, maps: maps}
  end

  defp parse_seeds!("seeds: " <> numbers), do: parse_numbers!(numbers)

  defp parse_map!(map) do
    [_header | numbers_list] = String.split(map, "\n")

    Enum.map(numbers_list, fn numbers ->
      [dst_start, src_start, size] = parse_numbers!(numbers)
      src_range = src_start..(src_start + size - 1)
      delta = dst_start - src_start
      {src_range, delta}
    end)
  end

  defp parse_numbers!(input),
    do: Regex.scan(@number_pattern, input) |> Enum.map(fn [_, num] -> String.to_integer(num) end)

  defmodule Part1 do
    def solve(input) do
      %{seeds: seeds, maps: maps} = Aoc2023.Day05.parse_almanac!(input)

      seeds
      |> Enum.map(&Aoc2023.Day05.run_seed_through_almanac(&1, maps))
      |> Enum.min()
    end
  end

  defmodule Part2 do
    def solve(input) do
      %{seeds: seed_input, maps: maps} = Aoc2023.Day05.parse_almanac!(input)

      seed_input
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, len] -> start..(start + len - 1) end)
      |> Enum.flat_map(&Aoc2023.Day05.run_seed_range_through_almanac(&1, maps))
      |> Enum.map(fn %Range{first: first} -> first end)
      |> Enum.min()
    end
  end
end
