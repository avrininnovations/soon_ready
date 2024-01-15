defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form do
  use Phoenix.Component
  import Phoenix.HTML.Form

  attr :placeholder, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  def text_input(assigns) do
    ~H"""
    <%= text_input(@field.form, @field.field, Keyword.new(@rest)) %>
    """
  end

  slot :inner_block, required: true

  def submit(assigns) do
    ~H"""
    <button name="submit"><%= render_slot(@inner_block) %></button>
    """
  end
end
