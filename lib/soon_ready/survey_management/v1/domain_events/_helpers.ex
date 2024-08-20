defmodule SoonReady.SurveyManagement.V1.DomainEvents.Helpers do
  alias SoonReady.SurveyManagement.V1.DomainConcepts.SurveyPage

  # TODO: Generalize
  def cast_stored(pages_dumped_data) do
    pages_dumped_data = Enum.map(pages_dumped_data, &normalize/1)
    Ash.Type.cast_stored({:array, SurveyPage}, pages_dumped_data, [])
  end

  def cast_stored(type, data, constraints) do
    data = Enum.map(data, &normalize/1)
    Ash.Type.cast_stored(type, data, constraints)
  end

  defp normalize(map) do
    map
    |> Enum.map(&do_normalize/1)
    |> Enum.into(%{})
  end

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
