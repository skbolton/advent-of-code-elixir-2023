defmodule AdventOfCode.Day05 do
  def part1(input) do
    input
    |> parse()
    |> find_closest_location()
  end

  def part2(input) do
    input
    |> parse2()
    |> find_closest_location()
  end

  def parse(input) do
    ["seeds: " <> seed_values | ranges] = String.split(input, "\n\n", trim: true)

    seeds =
      seed_values
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(fn seed -> {{seed, seed}, :seed} end)
      |> Enum.into(Hallux.IntervalMap.new())

    [
      seeds
      | Enum.map(ranges, fn range ->
          range
          |> String.split("\n", trim: true)
          # get rid of category header line
          |> tl()
          |> Enum.map(fn interval ->
            interval
            |> String.split(" ", trim: true)
            |> Enum.map(&String.to_integer/1)
          end)
          |> Enum.map(fn [destination, source, count] ->
            {{source, source + count}, {destination, destination + count}}
          end)
          |> Enum.into(Hallux.IntervalMap.new())
        end)
    ]
  end

  def parse2(input) do
    ["seeds: " <> seed_values | ranges] = String.split(input, "\n\n", trim: true)

    seeds =
      seed_values
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, count] -> {{start, start + count}, :seed} end)
      |> Enum.into(Hallux.IntervalMap.new())

    [
      seeds
      | ranges
        |> Enum.map(fn range ->
          range
          |> String.split("\n", trim: true)
          # get rid of category header line
          |> tl()
          |> Enum.map(fn interval ->
            interval
            |> String.split(" ", trim: true)
            |> Enum.map(&String.to_integer/1)
          end)
          |> Enum.map(fn [destination, source, count] ->
            {{source, source + count}, {destination, destination + count}}
          end)
          |> Enum.into(Hallux.IntervalMap.new())
        end)
    ]
  end

  def find_closest_location([seeds | categories]) do
    IO.inspect(Enum.at(categories, 5))

    seeds
    |> Enum.reduce(:infinity, fn {seed_interval, :seed}, smallest_found ->
      seed_interval
      |> walk_intervals(categories)
      |> elem(0)
      |> min(smallest_found)
    end)
  end

  def walk_intervals(point, []) do
    point
  end

  def walk_intervals({start, stop}, [next_category | remaining_categories]) do
    case Hallux.IntervalMap.interval_search(next_category, {start, stop}) do
      {:ok, {source_start, _source_end}, {dest_start, _dest_end}} ->
        walk_intervals(
          {dest_start + (start - source_start), dest_start + (start - source_start)},
          remaining_categories
        )

      {:error, :not_found} ->
        walk_intervals({start, stop}, remaining_categories)
    end
  end
end
