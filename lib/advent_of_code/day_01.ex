defmodule AdventOfCode.Day01 do
  import AdventOfCode.Helpers

  def part1(input) do
    input
    |> split_lines()
    |> Enum.reduce(0, fn row, count ->
      row
      |> String.replace(~r|\D|, "", global: true)
      |> String.codepoints()
      |> scan_string({_first = nil, _last = nil})
      |> case do
        {first, nil} ->
          String.to_integer("#{first}#{first}")

        {first, last} ->
          String.to_integer("#{first}#{last}")
      end
      |> Kernel.+(count)
    end)
  end

  def part2(input) do
    input
    |> split_lines()
    |> Enum.reduce(0, fn row, count ->
      row
      |> String.codepoints()
      |> scan_string({_first = nil, _last = nil})
      |> case do
        {first, nil} ->
          String.to_integer("#{first}#{first}")

        {first, last} ->
          String.to_integer("#{first}#{last}")
      end
      |> Kernel.+(count)
    end)
  end

  def scan_string([num | rest], {nil, nil}) when is_digit(num),
    do: scan_string(rest, {num, nil})

  def scan_string([num | rest], {first, _}) when is_digit(num),
    do: scan_string(rest, {first, num})

  def scan_string(["o", "n", "e" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {1, nil})

  def scan_string(["o", "n", "e" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 1})

  def scan_string(["t", "w", "o" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {2, nil})

  def scan_string(["t", "w", "o" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 2})

  def scan_string(["t", "h", "r", "e", "e" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {3, nil})

  def scan_string(["t", "h", "r", "e", "e" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 3})

  def scan_string(["f", "o", "u", "r" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {4, nil})

  def scan_string(["f", "o", "u", "r" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 4})

  def scan_string(["f", "i", "v", "e" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {5, nil})

  def scan_string(["f", "i", "v", "e" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 5})

  def scan_string(["s", "i", "x" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {6, nil})

  def scan_string(["s", "i", "x" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 6})

  def scan_string(["s", "e", "v", "e", "n" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {7, nil})

  def scan_string(["s", "e", "v", "e", "n" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 7})

  def scan_string(["e", "i", "g", "h", "t" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {8, nil})

  def scan_string(["e", "i", "g", "h", "t" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 8})

  def scan_string(["n", "i", "n", "e" | _] = list, {nil, nil}),
    do: scan_string(tl(list), {9, nil})

  def scan_string(["n", "i", "n", "e" | _] = list, {first, _}),
    do: scan_string(tl(list), {first, 9})

  def scan_string([_ | rest], numbers), do: scan_string(rest, numbers)
  def scan_string([], numbers), do: numbers
end
