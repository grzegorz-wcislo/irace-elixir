defmodule Gallium.Parser do
  @args [
    max_experiments: :integer,
    dims: :integer,
    limit: :string,
    population_size: :integer,
    selection: :string,
    crossover: :string,
    crossover_points: :integer,
    crossover_alpha: :float,
    crossover_eta: :float,
    mutation: :string,
    mutation_probability: :float,
    mutation_sigma: :float,
    topology: :string,
    migration_size: :integer,
    emigration_selection: :string,
    immigration_selection: :string,
    interval: :integer,
    populations: :integer
  ]

  def get_options(input) do
    {instance_file, argv} = instance_file_and_agrv(input)

    options = instance_option(instance_file) ++ argv_options(argv)
    struct(Gallium.Options, options)
  end

  defp instance_file_and_agrv(input) do
    [_, _, _, instance_file | argv] = OptionParser.split(input)
    {instance_file, argv}
  end

  defp instance_option(instance_file) do
    instance =
      instance_file
      |> :filename.basename()
      |> :filename.rootname()

    [instance: instance]
  end

  defp argv_options(argv) do
    argv
    |> OptionParser.parse(strict: @args)
    |> elem(0)
  end
end
