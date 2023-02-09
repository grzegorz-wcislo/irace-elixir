defmodule Log do
  @real_representation {MeowNx.RepresentationSpec, :real}
  @binary_representation {MeowNx.RepresentationSpec, :binary}
  @representations [@real_representation, @binary_representation]

  defp compile_metrics(funs) do
    fn genomes, fitness ->
      funs
      |> Enum.map(fn fun -> fun.(genomes, fitness) end)
      |> List.to_tuple()
    end
  end

  def log_metrics(metrics, opts \\ []) when is_map(metrics) and is_list(opts) do
    interval = Keyword.get(opts, :interval, 1)

    {keys, funs} = Enum.unzip(metrics)
    fun = compile_metrics(funs)

    %Meow.Op{
      name: "Log: metrics",
      requires_fitness: true,
      invalidates_fitness: false,
      in_representations: @representations,
      impl: fn population, _ctx ->
        if rem(population.generation, interval) == 0 do
          result =
            fun
            |> Nx.Defn.jit([population.genomes, population.fitness])
            |> Nx.backend_transfer()

          entries =
            result
            |> Tuple.to_list()
            |> Enum.zip(keys)
            |> Enum.map(fn {value, key} ->
            if not is_struct(value, Nx.Tensor) or Nx.shape(value) != {} do
              raise ArgumentError,
              "expected metric function to return a scalar, but #{inspect(key)} returned #{inspect(value)}"
            end

            {key, Nx.to_scalar(value)}
          end)

            update_in(population.log[:metrics], fn metrics ->
              Enum.reduce(entries, metrics || %{}, fn {key, value}, metrics ->
                point = {population.generation, :erlang.monotonic_time(), value}
                Map.update(metrics, key, [point], &[point | &1])
              end)
            end)
        else
          population
        end
      end
    }
  end
end

Meow.objective(&Gallium.Functions.rastrigin/1)
|> Meow.add_pipeline(
  MeowNx.Ops.init_real_random_uniform(10, 10, -5.12, 5.12),
  Meow.pipeline([
    MeowNx.Ops.selection_tournament(10),
    MeowNx.Ops.crossover_uniform(0.5),
    MeowNx.Ops.mutation_shift_gaussian(0.01),
    MeowNx.Ops.log_best_individual(),
    Log.log_metrics(%{mean: &MeowNx.Metric.fitness_mean/2}),
    Meow.Ops.max_generations(100)
  ]),
  duplicate: 3
)
|> Meow.run()
|> IO.inspect()
