defmodule AdventOfCode.Day07.Hand do
  defstruct [:hand, :rank, :bet, joker: false]

  def new(hand, bet, joker \\ false) do
    __MODULE__
    |> struct(hand: hand, bet: bet, joker: joker)
    |> struct!(rank: calculate_rank(hand, joker))
  end

  # They have the same rank compare hands
  def compare(
        %__MODULE__{rank: rank, hand: hand1_cards},
        %__MODULE__{rank: rank, hand: hand2_cards}
      ) do
    compare_hands(hand1_cards, hand2_cards)
  end

  def compare(%__MODULE__{rank: rank1}, %__MODULE__{rank: rank2}) do
    if rank1 > rank2 do
      :gt
    else
      :lt
    end
  end

  defp calculate_rank(hand, _joker = false) do
    hand
    |> Enum.sort()
    |> count_copies(%{})
    |> Map.values()
    |> Enum.sort(:desc)
    |> case do
      # five of a kind
      [5] -> 1
      # four of a kind
      [4, 1] -> 2
      # full house
      [3, 2] -> 3
      [3, 1, 1] -> 4
      # two pair
      [2, 2, 1] -> 5
      # one pair
      [2, 1, 1, 1] -> 6
      [1, 1, 1, 1, 1] -> 7
    end
  end

  defp calculate_rank(hand, _joker = true) do
    hand
    |> Enum.sort()
    |> count_copies(%{})
    # remove jokers - any missing cards are now wiles
    |> Map.delete("J")
    |> Map.values()
    |> Enum.sort(:desc)
    |> case do
      # FIVE OF A KIND
      # hand full of jokers
      [] ->
        1

      # if you hand is a count of only one card then the rest can be jokers
      # giving you five of a kind
      [_single_card] ->
        1

      # FOUR OF A KIND
      [4, 1] ->
        2

      [2, 1] ->
        2

      [3, 1] ->
        2

      [1, 1] ->
        2

      # FULL HOUSE
      [3, 2] ->
        3

      [2, 2] ->
        3

      # THREE OF A KIND
      [3, 1, 1] ->
        4

      [2, 1, 1] ->
        4

      [1, 1, 1] ->
        3

      # TWO PAIR
      [2, 2, 1] ->
        5

      # ONE PAIR
      [2, 1, 1, 1] ->
        6

      [1, 1, 1, 1] ->
        6

      # HIGH CARD
      [1, 1, 1, 1, 1] ->
        7
    end
  end

  defp count_copies([x, x, x, x, x | rest], copies), do: count_copies(rest, Map.put(copies, x, 5))
  defp count_copies([x, x, x, x | rest], copies), do: count_copies(rest, Map.put(copies, x, 4))
  defp count_copies([x, x, x | rest], copies), do: count_copies(rest, Map.put(copies, x, 3))
  defp count_copies([x, x | rest], copies), do: count_copies(rest, Map.put(copies, x, 2))
  defp count_copies([x | rest], copies), do: count_copies(rest, Map.put(copies, x, 1))
  defp count_copies([], copies), do: copies

  # comparing the same card
  def compare_hands([x | hand1_rest], [x | hand2_rest]), do: compare_hands(hand1_rest, hand2_rest)

  def compare_hands(["A" | _], [_card | _]), do: :lt
  def compare_hands([_opposing_card | _], ["A" | _]), do: :gt

  def compare_hands(["K" | _], ["A" | _]), do: :gt
  def compare_hands(["K" | _], [_opposing_card | _]), do: :lt

  def compare_hands(["A" | _], ["K" | _]), do: :lt
  def compare_hands([_card | _], ["K" | _]), do: :gt

  def compare_hands(["Q" | _], [opposing_card | _]),
    do: if(opposing_card in ["A", "K"], do: :gt, else: :lt)

  def compare_hands([opposing_card | _], ["Q" | _]),
    do: if(opposing_card in ["A", "K"], do: :lt, else: :gt)

  # part 1 - could refactor to get both solutions to work here
  # def compare_hands(["J" | _], [opposing_card | _]),
  #   do: if(opposing_card in ["A", "K", "Q"], do: :gt, else: :lt)
  #
  # def compare_hands([opposing_card | _], ["J" | _]),
  #   do: if(opposing_card in ["A", "K", "Q"], do: :lt, else: :gt)

  # sink j's value in ranking
  def compare_hands(["J" | _], [_card2 | _]), do: :gt
  def compare_hands([_card1 | _], ["J" | _]), do: :lt

  def compare_hands(["T" | _], [opposing_card | _]),
    do: if(opposing_card in ["A", "K", "Q"], do: :gt, else: :lt)

  def compare_hands([opposing_card | _], ["T" | _]),
    do: if(opposing_card in ["A", "K", "Q"], do: :lt, else: :gt)

  def compare_hands([card1 | _rest1], [card2 | _rest2]) do
    # NOTE: String numbers comparison here
    # A K Q J T 9 8 7 6 5 4 3 2 1 -> lower numbers are higher in this system
    if card1 > card2 do
      :lt
    else
      :gt
    end
  end
end

defmodule AdventOfCode.Day07 do
  import AdventOfCode.Helpers
  alias AdventOfCode.Day07.Hand

  def part1(input) do
    input
    |> split_lines()
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [hand, bid] ->
      {
        String.split(hand, "", trim: true),
        String.to_integer(bid)
      }
    end)
    |> Enum.map(fn {hand, bet} -> Hand.new(hand, bet, _joker = false) end)
    |> Enum.sort({:desc, Hand})
    |> Enum.with_index()
    |> Enum.map(fn {%Hand{bet: bet}, pos} -> bet * (pos + 1) end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> split_lines()
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [hand, bid] ->
      {
        String.split(hand, "", trim: true),
        String.to_integer(bid)
      }
    end)
    |> Enum.map(fn {hand, bet} -> Hand.new(hand, bet, _joker = true) end)
    |> Enum.sort({:desc, Hand})
    |> Enum.with_index(1)
    |> Enum.map(fn {%Hand{bet: bet}, pos} -> bet * pos end)
    |> Enum.sum()
  end
end
