defmodule SoonReady.Repo.Migrations.CreateTableEncryptionPersonalIdentifiableInformationEncryptionKey do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:encryption__personal_identifiable_information_encryption_key,
             primary_key: false
           ) do
      add :id, :uuid, null: false, primary_key: true
      add :encoded_key, :text, null: false
    end
  end

  def down do
    drop table(:encryption__personal_identifiable_information_encryption_key)
  end
end
