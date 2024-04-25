defmodule SoonReady.Repo.Migrations.RenameCloakKeyColumnToEncodedCloakKey do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    rename table(:quantifying_needs__survey_response__encryption__ciphers), :cloak_key,
      to: :encoded_cloak_key
  end

  def down do
    rename table(:quantifying_needs__survey_response__encryption__ciphers), :encoded_cloak_key,
      to: :cloak_key
  end
end