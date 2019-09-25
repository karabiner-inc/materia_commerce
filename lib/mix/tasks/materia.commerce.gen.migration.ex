defmodule Mix.Tasks.MateriaCommerce.Gen.Migration do
  @shortdoc "Generates MateriaCommerce's migration files."

  use Mix.Task
  alias Mix.Tasks.Materia.Gen.Migration

  @migrations_file_path "priv/repo/migrations"
  @migration_module_path "deps/materia_commerce/lib/mix/templates"

  @doc false
  def run(args) do
    args
    |> Migration.setting_migration_module_path(@migration_module_path)
    |> Migration.create_migration_files(@migrations_file_path, "materia_commerce")
  end
end
