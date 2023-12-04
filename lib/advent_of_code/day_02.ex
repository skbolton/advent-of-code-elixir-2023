defmodule AdventOfCode.Day02 do
  import AdventOfCode.Helpers

  def part1(input) do
    input
    |> split_lines()
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn ["Game " <> game_number | reveals] ->
      [String.to_integer(game_number) | reveals]
    end)
    |> Enum.map(fn [game, reveals] ->
      [
        game,
        reveals
        |> String.split("; ")
        |> Enum.map(fn reveal ->
          reveal
          |> String.split(", ")
          |> Enum.map(fn colors ->
            colors
            |> String.split(" ")
            |> Enum.reverse()
            |> then(fn [color, count] -> {color, String.to_integer(count)} end)
          end)
        end)
      ]
    end)
    |> Enum.reject(fn [_game, reveals] ->
      Enum.any?(reveals, fn reveal ->
        Enum.find(reveal, fn
          {"blue", count} when count > 14 ->
            true

          {"red", count} when count > 12 ->
            true

          {"green", count} when count > 13 ->
            true

          _valid ->
            false
        end)
      end)
    end)
    |> Enum.map(&List.first/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> split_lines()
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn ["Game " <> game_number | reveals] ->
      [String.to_integer(game_number) | reveals]
    end)
    |> Enum.map(fn [game, reveals] ->
      [
        game,
        reveals
        |> String.split("; ")
        |> Enum.map(fn reveal ->
          reveal
          |> String.split(", ")
          |> Enum.map(fn colors ->
            colors
            |> String.split(" ")
            |> Enum.reverse()
            |> then(fn [color, count] -> {color, String.to_integer(count)} end)
          end)
          |> Enum.into(%{})
        end)
      ]
    end)
    |> Enum.map(fn [_game_number, reveals] ->
      Enum.reduce(reveals, %{"blue" => 0, "red" => 0, "green" => 0}, fn reveal, maxes ->
        Enum.reduce(reveal, maxes, fn {color, count}, maxes ->
          Map.put(maxes, color, max(count, Map.get(maxes, color)))
        end)
      end)
    end)
    |> Enum.map(fn minimums ->
      Enum.product(Map.values(minimums))
    end)
    |> Enum.sum()
  end
end
