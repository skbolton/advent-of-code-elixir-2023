defmodule AdventOfCode.Day04 do
  import AdventOfCode.Helpers

  def part1(input) do
    input
    |> split_lines()
    |> Enum.map(&String.replace(&1, ~r/^Card \d+: /, ""))
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.map(fn [haves, winning] ->
      haves =
        haves
        |> String.split(" ", trim: true)
        |> MapSet.new()

      winning =
        winning
        |> String.split(" ", trim: true)
        |> MapSet.new()

      [haves, winning]
    end)
    |> Enum.map(fn [have, winning] ->
      winning
      |> MapSet.intersection(have)
      |> Enum.reduce({_sum = 0, _multiplier = 1}, fn
        _winning_nr, {sum, 1} ->
          {sum + 1, 2}

        _winning_nr, {sum, 2} ->
          {sum * 2, 2}
      end)
      |> elem(0)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> split_lines()
    |> Enum.map(&String.replace(&1, ~r/^Card \d+: /, ""))
    |> Enum.map(fn turn ->
      [haves, winning] = String.split(turn, "|")

      haves =
        haves
        |> String.split(" ", trim: true)
        |> MapSet.new()

      winning =
        winning
        |> String.split(" ", trim: true)
        |> MapSet.new()

      winning
      |> MapSet.intersection(haves)
      |> Enum.count()
    end)
    |> Enum.map(&List.wrap/1)
    |> count_scratch_cards(0)
  end

  def count_scratch_cards([], acc), do: acc

  def count_scratch_cards([round | next_rounds], acc) do
    round
    |> Enum.reduce(next_rounds, fn round, next_rounds ->
      additional_cards =
        next_rounds
        |> Enum.take(round)
        |> Enum.map(&List.first/1)

      zip_rounds(next_rounds, additional_cards)
    end)
    |> count_scratch_cards(acc + Enum.count(round))
  end

  def zip_rounds([], _additional_wins), do: []
  def zip_rounds(remaining_rounds, []), do: remaining_rounds

  def zip_rounds([round | next_rounds], [additional | next_additional]) do
    [[additional | round] | zip_rounds(next_rounds, next_additional)]
  end
end
