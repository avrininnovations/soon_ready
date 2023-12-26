defmodule SoonReady.Utils do
  def is_equal_or_subset?(investigated_value, comparison_value, nested \\ true)
  def is_equal_or_subset?(investigated_value, comparison_value, nested)
      when is_map(investigated_value) and is_map(comparison_value)
  do
    Enum.all?(Map.keys(investigated_value), fn key ->
      case Map.has_key?(comparison_value, key) do
        true ->
          if nested do
            is_equal_or_subset?(Map.get(investigated_value, key), Map.get(comparison_value, key))
          else
            Map.get(investigated_value, key) == Map.get(comparison_value, key)
          end
        false ->
          false
      end
    end)
  end

  def is_equal_or_subset?(investigated_list, comparison_list, _nested)
      when is_list(investigated_list) and is_list(comparison_list)
  do
    value_pairs = Enum.zip(investigated_list, comparison_list)
    Enum.all?(value_pairs, fn {investigated_value, comparison_value} ->
      is_equal_or_subset?(investigated_value, comparison_value)
    end)
  end

  def is_equal_or_subset?(investigated_value, comparison_value, _nested) do
    investigated_value == comparison_value
  end
end
