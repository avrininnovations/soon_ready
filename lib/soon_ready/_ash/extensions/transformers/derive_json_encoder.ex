defmodule SoonReady.Ash.Extensions.Transformers.DeriveJsonEncoder do
  use Spark.Dsl.Transformer

  def after?(_), do: true

  def transform(dsl) do
    public_attribute_names =
      dsl
      |> Ash.Resource.Info.public_fields()
      |> Enum.map(&(&1.name))

    block = quote do
      @derive {Jason.Encoder, only: unquote(public_attribute_names)}
    end

    {:ok, Spark.Dsl.Transformer.eval(dsl, [], block)}
  end
end
