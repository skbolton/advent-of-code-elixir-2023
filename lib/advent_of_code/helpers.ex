defmodule AdventOfCode.Helpers do
  defguard is_digit(digit) when digit in ~w(0 1 2 3 4 5 6 7 8 9)

  def split_lines(input), do: String.split(input, "\n", trim: true)
end
