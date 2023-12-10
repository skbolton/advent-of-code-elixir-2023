defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = """
    Time:      7  15   30
    Distance:  9  40  200
    """

    assert 288 = part1(input)
  end

  test "part2" do
    input = """
    Time:      71530
    Distance:  940200
    """

    assert 71503 = part2(input)
  end
end
