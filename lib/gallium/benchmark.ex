defmodule Gallium.Benchmark do
  def bench1(generations, pop_size, dims, type) do
    Meow.objective(&Gallium.Functions.rastrigin/1)
    |> Meow.add_pipeline(
      MeowNx.Ops.init_real_random_uniform(pop_size, dims, -5.12, 5.12),
      Meow.pipeline([
        MeowNx.Ops.selection_tournament(pop_size),
        MeowNx.Ops.crossover_uniform(0.5),
        MeowNx.Ops.mutation_replace_uniform(0.005, -5.12, 5.12),
        MeowNx.Ops.log_best_individual(),
        Meow.Ops.max_generations(generations)
      ])
    )
    |> Meow.run()
    |> format_results(generations, pop_size, dims, type)
  end

  defmodule OneMax do
    import Nx.Defn

    defn evaluate(genomes) do
      Nx.sum(genomes, axes: [1])
    end
  end

  def bench1_onemax(generations, pop_size, dims, type) do
    Meow.objective(&OneMax.evaluate/1)
    |> Meow.add_pipeline(
      MeowNx.Ops.init_binary_random_uniform(pop_size, dims),
      Meow.pipeline([
        MeowNx.Ops.selection_tournament(pop_size),
        MeowNx.Ops.crossover_uniform(0.5),
        MeowNx.Ops.mutation_bit_flip(0.001),
        MeowNx.Ops.log_best_individual(),
        Meow.Ops.max_generations(generations)
      ])
    )
    |> Meow.run()
    |> format_results_onemax(generations, pop_size, dims, type)
  end

  def bench2(generations, pop_size, dims, populations) do
    Meow.objective(&Gallium.Functions.rastrigin/1)
    |> Meow.add_pipeline(
      MeowNx.Ops.init_real_random_uniform(pop_size, dims, -5.12, 5.12),
      Meow.pipeline([
        MeowNx.Ops.selection_tournament(pop_size),
        MeowNx.Ops.crossover_uniform(0.5),
        MeowNx.Ops.mutation_replace_uniform(0.005, -5.12, 5.12),
        Meow.Ops.emigrate(MeowNx.Ops.selection_tournament(5), &Meow.Topology.fully_connected/2,
          interval: 10
        ),
        Meow.Ops.immigrate(&MeowNx.Ops.selection_tournament/1, interval: 10, blocking: false),
        MeowNx.Ops.log_best_individual(),
        Meow.Ops.max_generations(generations)
      ]),
      duplicate: populations
    )
    |> Meow.run(nodes: [node() | :erlang.nodes()])
    |> format_results(
      generations,
      pop_size,
      dims,
      "#{populations},#{length(:erlang.nodes()) + 1}"
    )
  end

  defp format_results(results, generations, pop_size, dims, type) do
    max_fitness = hd(results.population_reports).population.log.best_individual.fitness
    cpus = :erlang.system_info(:logical_processors_available)

    Enum.join(
      [
        type,
        "rastrigin",
        cpus,
        generations,
        pop_size,
        dims,
        results.total_time_us / 1_000_000,
        -max_fitness
      ],
      ","
    )
    |> IO.puts()
  end

  defp format_results_onemax(results, generations, pop_size, dims, type) do
    max_fitness = hd(results.population_reports).population.log.best_individual.fitness
    cpus = :erlang.system_info(:logical_processors_available)

    Enum.join(
      [
        type,
        "onemax",
        cpus,
        generations,
        pop_size,
        dims,
        results.total_time_us / 1_000_000,
        max_fitness
      ],
      ","
    )
    |> IO.puts()
  end
end
