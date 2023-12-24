defmodule SoonReady.Utils do
  def partially_equal?(investigated_value, comparison_value, nested \\ true)
  def partially_equal?(investigated_value, comparison_value, nested)
      when is_map(investigated_value) and is_map(comparison_value)
  do
    Enum.all?(Map.keys(comparison_value), fn key ->
      case Map.has_key?(investigated_value, key) do
        true ->
          if nested do
            partially_equal?(Map.get(investigated_value, key), Map.get(comparison_value, key))
          else
            Map.get(investigated_value, key) == Map.get(comparison_value, key)
          end
        false ->
          false
      end
    end)
  end

  def partially_equal?(investigated_value, comparison_value, nested)
      when is_list(investigated_value) and is_list(comparison_value)
  do
    Enum.all?(comparison_value, fn value ->
      Enum.any?(investigated_value, fn item ->
        if nested do
          partially_equal?(item, value)
        else
          item == value
        end
      end)
    end)
  end

  def partially_equal?(investigated_value, comparison_value, nested) do
    investigated_value == comparison_value
  end
end
