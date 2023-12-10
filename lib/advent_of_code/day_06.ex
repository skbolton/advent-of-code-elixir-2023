defmodule AdventOfCode.Day06 do
  import AdventOfCode.Helpers

  def part1(input) do
    input
    |> parse()
    |> Enum.map(&find_winning_runs/1)
    |> Enum.product()
  end

  def part2(_args) do
  end

  def parse(input) do
    input
    |> split_lines()
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> tl()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
  end

  def find_winning_runs({time, score_to_beat}) do
    1..time
    |> Enum.to_list()
    |> Enum.reduce({_win_count = 0, _speed = 0}, fn tick, {win_count, speed} ->
      rounds_left = time - tick + 1

      if speed * rounds_left > score_to_beat do
        {win_count + 1, speed + 1}
      else
        {win_count, speed + 1}
      end
    end)
    |> elem(0)
  end
end
