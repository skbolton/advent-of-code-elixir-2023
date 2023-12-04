defmodule CoordinateGrid do
  @typedoc """
  User provided value being stored at `t:coordinate` in `t:grid`.
  """
  @type value :: term()

  @typedoc """
  x,y coordinate for location in `t`.
  """
  @type coordinate :: {integer(), integer()}

  @typedoc """
  Representation of item at a `t:coordinate` in `t`.
  """
  @type member(a) :: {:value, a} | nil
  @type member :: {:value, value()} | nil

  @type t(a) :: %__MODULE__{g: %{coordinate() => member(a)}}
  @type t :: %__MODULE__{g: %{coordinate() => member()}}

  @typedoc """
  A representation of a valid `t:coordinate` in `t` and `t:value` it is
  holding.
  """
  @type cell :: nil | {coordinate(), value()}

  @type predicate :: (term -> boolean())

  defstruct [:g]

  @spec new() :: t()
  @doc """
  Creates a new `CoordinateGrid`.
  """
  def new() do
    %__MODULE__{g: %{}}
  end

  @spec add(t(), coordinate(), value()) :: t()
  @doc """
  Add `value` to `grid` at `coord`.
  """
  def add(grid, coord, value) do
    %__MODULE__{
      g: Map.put(grid.g, coord, {:value, value})
    }
  end

  @spec get(t(), coordinate()) :: cell()
  @doc """
  Get value of `grid` at `coord` returning nil in the case of an empty
  `t:cell`.
  """
  def get(grid, coord) do
    case Map.get(grid.g, coord) do
      nil -> nil
      {:value, value} -> {coord, value}
    end
  end

  @spec has_cell?(t(), coordinate()) :: boolean()
  @spec has_cell?(t(), coordinate(), predicate()) :: boolean()
  @doc """
  Checks to see if `t` at `t:coord` contains a `t:cell`.

  An optional predicate can be passed to further test found `t:cell`.
  """
  def has_cell?(grid, coord, predicate \\ &always_true/1) do
    case get(grid, coord) do
      nil ->
        false

      cell ->
        apply(predicate, [cell])
    end
  end

  @spec neighboring_coordinates(coordinate()) :: [coordinate(), ...]
  @doc """
  List of all possible neighboring coordinates for `cord`.
  """
  def neighboring_coordinates({x, y}) do
    for x <- [x, x + 1, x - 1],
        y <- [y, y - 1, y + 1] do
      {x, y}
    end
    # filter out current coord
    |> Enum.reject(&match?({^x, ^y}, &1))
  end

  @spec neighbors(t(), coordinate()) :: [cell()]
  @spec neighbors(t(), coordinate(), predicate()) :: [cell()]
  @doc """
  Return list of immediate neighboaring coordinates to `coord` who are `t:cell`s
  in `grid`.

  An optional predicate function can be passed as an additional test on found
  neighbors.
  """
  def neighbors(grid, coord, predicate \\ &always_true/1) do
    coord
    |> neighboring_coordinates()
    |> Enum.reduce([], fn coord, found_neighbors ->
      cell = get(grid, coord)

      cond do
        cell == nil -> found_neighbors
        apply(predicate, [cell]) -> [cell | found_neighbors]
        _failed_predicate = true -> found_neighbors
      end
    end)
  end

  @spec neighbors?(t(), coordinate()) :: boolean()
  @spec neighbors?(t(), coordinate(), predicate()) :: boolean()
  @doc """
  Check if `coord` has any neighbors on `grid`.

  An optional predicate function can be passed as an additional test on found
  neighbors.
  """
  def neighbors?(grid, coord, predicate \\ &always_true/1) do
    coord
    |> neighboring_coordinates()
    |> Enum.any?(fn coordinate ->
      case get(grid, coordinate) do
        nil -> false
        cell -> apply(predicate, [cell])
      end
    end)
  end

  @spec right?(t(), coordinate()) :: boolean()
  @doc """
  Returns whether `grid` contains a coord to the immediate right of `coord`.

  An optional predicate can be passed to further test found `t:cell`.
  """
  def right?(grid, coord, predicate \\ &always_true/1) do
    case right(grid, coord) do
      nil ->
        false

      to_right ->
        apply(predicate, [to_right])
    end
  end

  @spec left(t(), coordinate()) :: cell()
  @doc """
  Get value to left of `coord` in `grid`.
  """
  def left(grid, {x, y}) do
    get(grid, {x, y - 1})
  end

  @spec left?(t(), coordinate()) :: boolean()
  @spec left?(t(), coordinate(), predicate()) :: boolean()
  @doc """
  Returns whether `grid` contains a coord to the immediate left of `coord`.

  An optional predicate function can be passed as an additional test on found
  value.
  """
  def left?(grid, coord, predicate \\ &always_true/1) do
    case left(grid, coord) do
      nil ->
        false

      to_left ->
        apply(predicate, [to_left])
    end
  end

  @spec left_neighbors(t(), coordinate()) :: [cell()]
  @doc """
  List of connected neighbors to the left of `coord`.

  Returned list will be in order of coordinates from `coord` to furthest
  left.

  An optional predicate function can be passed as an additional test on
  continuing along path.
  """
  def left_neighbors(grid, coord, predicate \\ &always_true/1) do
    to_left = left(grid, coord)

    cond do
      to_left == nil ->
        []

      apply(predicate, [to_left]) ->
        [to_left | left_neighbors(grid, elem(to_left, 0), predicate)]

      _failed_predicate = true ->
        []
    end
  end

  @spec right(t(), coordinate()) :: nil | value()
  @doc """
  Get value to right of `coord` in `grid`.
  """
  def right(grid, {x, y}) do
    get(grid, {x, y + 1})
  end

  @spec right_neighbors(t(), coordinate()) :: [cell()]
  @doc """
  List of connected neighbors to the right of `coord`.

  Returned list will be in order of coordinates from `coord` to furthest
  right.

  An optional predicate function can be passed as an additional test on
  continuing along path.
  """
  def right_neighbors(grid, coord, predicate \\ &always_true/1) do
    to_right = right(grid, coord)

    cond do
      to_right == nil ->
        []

      apply(predicate, [to_right]) ->
        [to_right | right_neighbors(grid, elem(to_right, 0), predicate)]

      _failed_predicate = true ->
        []
    end
  end

  defp always_true(_value), do: true

  defimpl Enumerable do
    def count(grid) do
      {:ok, Kernel.map_size(grid.g)}
    end

    def slice(_grid) do
      {:error, __MODULE__}
    end

    def reduce(grid, acc, fun) do
      grid.g
      |> :maps.to_list()
      |> Enum.map(fn {coord, {:value, value}} -> {coord, value} end)
      |> Enumerable.List.reduce(acc, fun)
    end

    def member?(grid, {coordinate, _value}) do
      {:ok, CoordinateGrid.get(grid, coordinate) != nil}
    end
  end

  defimpl Collectable do
    def into(grid) do
      collector_function = fn
        grid_acc, {:cont, {{x, y}, value}} ->
          CoordinateGrid.add(grid_acc, {x, y}, value)

        grid_acc, :done ->
          grid_acc

        _map_set_acc, :halt ->
          :ok
      end

      {grid, collector_function}
    end
  end
end
