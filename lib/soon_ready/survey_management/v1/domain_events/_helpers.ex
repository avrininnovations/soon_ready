defmodule SoonReady.SurveyManagement.V1.DomainEvents.Helpers do
  alias SoonReady.SurveyManagement.V1.DomainConcepts.SurveyPage

  def cast_stored(type, data, constraints) do
    data = Enum.map(data, &normalize/1)
    Ash.Type.cast_stored(type, data, constraints)
  end

  defp normalize(map) when is_map(map) do
    map
    |> Enum.map(&do_normalize/1)
    |> Enum.into(%{})
  end

  defp normalize(value), do: value

  defp do_normalize({key, value}) when key in ["type", :type] do
    value =
      if is_atom(value) do
        value
      else
        String.to_existing_atom(value)
      end
    {to_string(key), value}
  end

  defp do_normalize({key, value}) when is_map(value) do
    {to_string(key), normalize(value)}
  end

  defp do_normalize({key, value}) when is_list(value) do
    {to_string(key), Enum.map(value, &normalize/1)}
  end

  defp do_normalize({key, value}) do
    {to_string(key), value}
  end
end
