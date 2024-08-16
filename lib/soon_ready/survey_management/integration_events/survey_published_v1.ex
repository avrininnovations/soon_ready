defmodule SoonReady.SurveyManagement.IntegrationEvents.SurveyPublishedV1 do
  use Ash.Resource,
    domain: SoonReady.SurveyManagement,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.V1.DomainConcepts.{SurveyPage, Trigger}

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :starting_page_id, :uuid, allow_nil?: false, public?: true
    attribute :pages_dumped_data, {:array, :map}, public?: true
    attribute :trigger, Trigger, public?: true
  end

  calculations do
    calculate :pages, {:array, SurveyPage}, fn [record], _context ->
      pages_dumped_data = Enum.map(record.pages_dumped_data, &normalize/1)
      {:ok, pages} = Ash.Type.cast_stored({:array, SurveyPage}, pages_dumped_data, [])
      {:ok, [pages]}
    end
  end

  changes do
    change load(:pages)
  end

  actions do
    default_accept [
      :survey_id,
      :starting_page_id,
      :pages_dumped_data,
      :trigger,
    ]
    defaults [:read]
    create :new
  end

  code_interface do
    define :new
  end

  def normalize(map) do
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
