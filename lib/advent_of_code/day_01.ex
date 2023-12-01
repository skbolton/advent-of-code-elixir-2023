defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(0, fn row, count ->
      row
      |> String.replace(~r|\D|, "", global: true)
      |> case do
        number when length(number) == 1 ->
          number

        number ->
          String.at(number, 0) <> String.last(number)
      end
      |> String.to_integer()
      |> Kernel.+(count)
    end)
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
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

  def scan_string(["1" | rest], {nil, nil}), do: scan_string(rest, {1, nil})
  def scan_string(["1" | rest], {first, _}), do: scan_string(rest, {first, 1})

  def scan_string(["o", "n", "e" | rest], {nil, nil}),
    do: scan_string(["n", "e" | rest], {1, nil})

  def scan_string(["o", "n", "e" | rest], {first, _}),
    do: scan_string(["n", "e" | rest], {first, 1})

  def scan_string(["2" | rest], {nil, nil}), do: scan_string(rest, {2, nil})
  def scan_string(["2" | rest], {first, _}), do: scan_string(rest, {first, 2})

  def scan_string(["t", "w", "o" | rest], {nil, nil}),
    do: scan_string(["w", "o" | rest], {2, nil})

  def scan_string(["t", "w", "o" | rest], {first, _}),
    do: scan_string(["w", "o" | rest], {first, 2})

  def scan_string(["3" | rest], {nil, nil}), do: scan_string(rest, {3, nil})
  def scan_string(["3" | rest], {first, _}), do: scan_string(rest, {first, 3})

  def scan_string(["t", "h", "r", "e", "e" | rest], {nil, nil}),
    do: scan_string(["h", "r", "e", "e" | rest], {3, nil})

  def scan_string(["t", "h", "r", "e", "e" | rest], {first, _}),
    do: scan_string(["h", "r", "e", "e" | rest], {first, 3})

  def scan_string(["4" | rest], {nil, nil}), do: scan_string(rest, {4, nil})
  def scan_string(["4" | rest], {first, _}), do: scan_string(rest, {first, 4})

  def scan_string(["f", "o", "u", "r" | rest], {nil, nil}),
    do: scan_string(["o", "u", "r" | rest], {4, nil})

  def scan_string(["f", "o", "u", "r" | rest], {first, _}),
    do: scan_string(["o", "u", "r" | rest], {first, 4})

  def scan_string(["5" | rest], {nil, nil}), do: scan_string(rest, {5, nil})
  def scan_string(["5" | rest], {first, _}), do: scan_string(rest, {first, 5})

  def scan_string(["f", "i", "v", "e" | rest], {nil, nil}),
    do: scan_string(["i", "v", "e" | rest], {5, nil})

  def scan_string(["f", "i", "v", "e" | rest], {first, _}),
    do: scan_string(["i", "v", "e" | rest], {first, 5})

  def scan_string(["6" | rest], {nil, nil}), do: scan_string(rest, {6, nil})
  def scan_string(["6" | rest], {first, _}), do: scan_string(rest, {first, 6})

  def scan_string(["s", "i", "x" | rest], {nil, nil}),
    do: scan_string(["i", "x" | rest], {6, nil})

  def scan_string(["s", "i", "x" | rest], {first, _}),
    do: scan_string(["i", "x" | rest], {first, 6})

  def scan_string(["7" | rest], {nil, nil}), do: scan_string(rest, {7, nil})
  def scan_string(["7" | rest], {first, _}), do: scan_string(rest, {first, 7})

  def scan_string(["s", "e", "v", "e", "n" | rest], {nil, nil}),
    do: scan_string(["e", "v", "e", "n" | rest], {7, nil})

  def scan_string(["s", "e", "v", "e", "n" | rest], {first, _}),
    do: scan_string(["e", "v", "e", "n" | rest], {first, 7})

  def scan_string(["8" | rest], {nil, nil}), do: scan_string(rest, {8, nil})
  def scan_string(["8" | rest], {first, _}), do: scan_string(rest, {first, 8})

  def scan_string(["e", "i", "g", "h", "t" | rest], {nil, nil}),
    do: scan_string(["i", "g", "h", "t" | rest], {8, nil})

  def scan_string(["e", "i", "g", "h", "t" | rest], {first, _}),
    do: scan_string(["i", "g", "h", "t" | rest], {first, 8})

  def scan_string(["9" | rest], {nil, nil}), do: scan_string(rest, {9, nil})
  def scan_string(["9" | rest], {first, _}), do: scan_string(rest, {first, 9})

  def scan_string(["n", "i", "n", "e" | rest], {nil, nil}),
    do: scan_string(["i", "n", "e" | rest], {9, nil})

  def scan_string(["n", "i", "n", "e" | rest], {first, _}),
    do: scan_string(["i", "n", "e" | rest], {first, 9})

  def scan_string([_ | rest], numbers), do: scan_string(rest, numbers)
  def scan_string([], numbers), do: numbers
end
