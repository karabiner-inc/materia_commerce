defmodule Mix.Tasks.MateriaCommerce.Gen.Migration do
  @shortdoc "Generates MateriaCommerce's migration files."

  use Mix.Task

  import Mix.Generator
  import Mix.Tasks.Guardian.Db.Gen.Migration
  alias Mix.Tasks.Materia.Gen.Migration, as: MateriaMigration

  @migrations_file_path "priv/repo/migrations"
  @migration_module_path "deps/materia_commerce/lib/mix/templates"

  @doc false
  def run(args) do
    args
    |> MateriaMigration.setting_migration_module_path(@migration_module_path)
    |> MateriaMigration.create_migration_files(@migrations_file_path, "materia")
  end
end
