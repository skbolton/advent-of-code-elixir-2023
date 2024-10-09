defmodule AdventOfCode.Day09 do
  import AdventOfCode.Helpers

  def part1(input) do
    input
    |> split_lines()
    |> Stream.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Stream.map(&build_sequence_end/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> split_lines()
    |> Stream.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Stream.map(&build_sequence_begin/1)
    |> Enum.sum()
  end

  def build_sequence_end([first | rest] = line) do
    if Enum.all?(line, fn value -> value == first end) do
      first
    else
      {diffs, last} =
        rest
        |> Enum.reduce({_diffs = [], first}, fn value, {diffs, previous} ->
          {[value - previous | diffs], value}
        end)

      last + build_sequence_end(Enum.reverse(diffs))
    end
  end

  def build_sequence_begin([first | rest] = line) do
    if Enum.all?(line, fn value -> value == first end) do
      first
    else
      {diffs, _last} =
        rest
        |> Enum.reduce({_diffs = [], first}, fn value, {diffs, previous} ->
          {[value - previous | diffs], value}
        end)

      first - build_sequence_begin(Enum.reverse(diffs))
    end
  end
end
