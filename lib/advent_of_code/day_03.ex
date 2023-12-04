defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> parse_grid()
    |> build_number_paths_near_symbols()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_grid()
    |> build_number_paths_by_gears()
  end

  @spec parse_grid(String.t()) :: CoordinateGrid.t({:digit | :symbol, String.t()})
  def parse_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.with_index()
    |> Enum.reduce([], fn {row_values, row}, coordinates ->
      row_values
      |> Enum.with_index()
      |> Enum.reduce(coordinates, fn
        {".", _col}, coordinates ->
          coordinates

        {digit, col}, coordinates when digit in ~w(0 1 2 3 4 5 6 7 8 9) ->
          [{{row, col}, {:digit, digit}} | coordinates]

        {symbol, col}, coordinates ->
          [{{row, col}, {:symbol, symbol}} | coordinates]
      end)
    end)
    |> Enum.into(CoordinateGrid.new())
  end

  def build_number_paths_near_symbols(grid) do
    grid
    |> Enum.reject(&is_symbol/1)
    |> Enum.reject(fn {coord, _value} -> CoordinateGrid.left?(grid, coord, &is_digit/1) end)
    |> Enum.filter(fn {coord, _value} = current_cell ->
      right_neighboring_digits = CoordinateGrid.right_neighbors(grid, coord, &is_digit/1)

      # PERF: Could add some caching to avoid duplicate coordinate lookups
      Enum.any?([current_cell | right_neighboring_digits], fn {coord, _value} ->
        CoordinateGrid.neighbors?(grid, coord, &is_symbol/1)
      end)
    end)
    # build up full numbers from digits along the path
    |> Enum.map(fn {coord, {:digit, value}} ->
      grid
      |> CoordinateGrid.right_neighbors(coord, &is_digit/1)
      |> Enum.reduce(value, fn {_coordinate, {:digit, value}}, number ->
        number <> value
      end)
      |> String.to_integer()
    end)
  end

  def build_number_paths_by_gears(grid) do
    grid
    |> Enum.filter(&is_gear/1)
    |> Enum.filter(fn {gear_coord, _value} ->
      CoordinateGrid.neighbors?(grid, gear_coord, &is_digit/1)
    end)
    |> Enum.map(fn {gear_coord, _value} ->
      grid
      |> CoordinateGrid.neighbors(gear_coord, &is_digit/1)
      |> Enum.map(fn {digit_coord, _value} = cell ->
        if CoordinateGrid.left?(grid, digit_coord, &is_digit/1) do
          grid
          |> CoordinateGrid.left_neighbors(digit_coord, &is_digit/1)
          |> List.last()
        else
          cell
        end
      end)
      |> Enum.reduce(%{}, fn {digit_coord, _value} = cell, acc ->
        Map.put(acc, digit_coord, cell)
      end)
    end)
    |> Enum.reject(&(map_size(&1) != 2))
    |> Enum.map(fn lefts ->
      Enum.map(lefts, fn {coord, {_coord, {:digit, value}}} ->
        grid
        |> CoordinateGrid.right_neighbors(coord, &is_digit/1)
        |> Enum.reduce(value, fn {_coord, {:digit, value}}, number ->
          number <> value
        end)
        |> String.to_integer()
      end)
    end)
    |> Enum.map(&Enum.product/1)
    |> Enum.sum()
  end

  defp is_digit({_coord, value}), do: match?({:digit, _value}, value)
  defp is_symbol({_coord, value}), do: match?({:symbol, _value}, value)
  defp is_gear({_coord, value}), do: match?({:symbol, "*"}, value)
end
