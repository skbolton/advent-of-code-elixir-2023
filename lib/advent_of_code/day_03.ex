defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index()
    |> Enum.reduce({_symbols = Map.new(), _digits = Map.new()}, fn {cells, row_nr}, coordinates ->
      cells
      |> Enum.with_index()
      |> Enum.reduce(coordinates, fn
        {".", _cell}, {_symbols, _digits} = coordinates ->
          coordinates

        {number, column_nr}, {symbols, digits} when number in ~w(0 1 2 3 4 5 6 7 8 9) ->
          {symbols, Map.put(digits, {row_nr, column_nr}, number)}

        {symbol, column_nr}, {symbols, digits} ->
          {Map.put(symbols, {row_nr, column_nr}, symbol), digits}
      end)
    end)
    |> sum_coords_near_symbols()
  end

  def part2(_args) do
  end

  def sum_coords_near_symbols({symbols, digits}) do
    Enum.filter(digits, fn {coord, _value} ->
      case neighbors(coord, symbols) do
        [] -> false
        _has_neigbors -> true
      end
    end)
    |> Enum.reduce(%{}, fn {coord, value}, sums ->
      case left_neighbors(coord, digits) do
        # we are the leftmost
        [] ->
          Map.put(
            sums,
            coord,
            Enum.reduce(right_neighbors(coord, digits), to_string(value), fn coord, sum ->
              sum <> Map.get(digits, coord)
            end)
          )

        lefts ->
          left_most =
            List.last(lefts)

          Map.put(
            sums,
            left_most,
            Enum.reduce(
              right_neighbors(left_most, digits),
              Map.get(digits, left_most),
              fn coord, sum ->
                sum <> Map.get(digits, coord)
              end
            )
          )
      end
    end)
    |> Enum.reduce(0, fn {_coord, value}, sum -> sum + String.to_integer(value) end)
  end

  def left_neighbor({row, col}, coords) do
    Map.get(coords, {row, col - 1})
  end

  def left_neighbors({row, col}, coords) do
    left = {row, col - 1}

    if Map.has_key?(coords, left) do
      [left | left_neighbors(left, coords)]
    else
      []
    end
  end

  def right_neighbors({row, col}, coords) do
    right = {row, col + 1}

    if Map.has_key?(coords, right) do
      [right | right_neighbors(right, coords)]
    else
      []
    end
  end

  def neighbors({row, col}, coords) do
    for row <- [row, row + 1, row - 1],
        col <- [col, col - 1, col + 1] do
      {row, col}
    end
    |> Enum.filter(fn {row, col} -> Map.has_key?(coords, {row, col}) end)
  end
end
