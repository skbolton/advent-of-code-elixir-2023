defmodule AdventOfCode.Day08 do
  import AdventOfCode.Helpers

  def part1(input) do
    [steps, nodes] = String.split(input, "\n\n", trim: true)

    graph =
      nodes
      |> split_lines()
      |> Enum.map(&String.split(&1, " = "))
      |> Enum.map(fn [location, connections] ->
        [
          location,
          connections
          |> String.replace(~r/\(|\)/, "")
          |> String.split(", ")
        ]
      end)
      |> Enum.map(fn [node, [left, right]] -> {node, {left, right}} end)
      |> Enum.into(Map.new())

    steps
    |> String.split("", trim: true)
    |> Stream.cycle()
    |> Stream.transform({graph, "AAA"}, fn
      _step, {_graph, "ZZZ"} = acc ->
        {:halt, acc}

      "L", {graph, location} ->
        {new_location, _right} = Map.get(graph, location)
        {[1], {graph, new_location}}

      "R", {graph, location} ->
        {_left, new_location} = Map.get(graph, location)
        {[1], {graph, new_location}}
    end)
    |> Enum.sum()
  end

  def part2(input) do
    [steps, nodes] = String.split(input, "\n\n", trim: true)
    steps = String.split(steps, "", trim: true)

    graph =
      nodes
      |> split_lines()
      |> Enum.map(&String.split(&1, " = "))
      |> Enum.map(fn [location, connections] ->
        [
          location,
          connections
          |> String.replace(~r/\(|\)/, "")
          |> String.split(", ")
        ]
      end)
      |> Enum.map(fn [node, [left, right]] -> {node, {left, right}} end)
      |> Enum.into(Map.new())

    graph
    |> Enum.filter(fn {key, _value} -> String.ends_with?(key, "A") end)
    |> Enum.map(fn {location, _value} ->
      steps
      |> Stream.cycle()
      |> Stream.transform({graph, location}, fn step, {graph, location} = acc ->
        cond do
          String.ends_with?(location, "Z") ->
            {:halt, acc}

          step == "L" ->
            {new_location, _right} = Map.get(graph, location)
            {[1], {graph, new_location}}

          step == "R" ->
            {_left, new_location} = Map.get(graph, location)
            {[1], {graph, new_location}}
        end
      end)
      |> Enum.sum()
    end)
    |> Enum.reduce(1, &lcm/2)
  end

  def lcm(a, b), do: div(abs(a * b), Integer.gcd(a, b))
end
