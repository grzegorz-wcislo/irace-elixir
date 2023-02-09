defmodule Gallium.Baseline do
  @moduledoc false

  @instances %{
    "rastrigin" => {&Gallium.Functions.rastrigin/1, -5.12, 5.12},
    "sphere" => {&Gallium.Functions.sphere/1, -500.0, 500.0},
    "schwefel" => {&Gallium.Functions.schwefel/1, -500.0, 500.0},
    "rosenbrock" => {&Gallium.Functions.rosenbrock/1, -500.0, 500.0},
    "styblinski_tang" => {&Gallium.Functions.styblinski_tang/1, -5, 5}
  }

  def model(%{instance: instance, dims: dims, batch_size: batch_size}) do
    {objective, min, max} = Map.fetch!(@instances, instance)

    Meow.objective(objective)
    |> Meow.add_pipeline(
      MeowNx.Ops.init_real_random_uniform(batch_size, dims, min, max),
      Meow.pipeline([
        MeowNx.Ops.mutation_replace_uniform(1, min, max),
        MeowNx.Ops.log_best_individual(),
        Meow.Ops.max_generations(100)
      ])
    )
  end

  def run(dims, batch_size) do
    options = %{instance: "rastrigin", dims: dims, batch_size: batch_size}

    report = Meow.run(model(options))

    report.population_reports
    |> Enum.map(fn result -> result.population.log.best_individual.fitness end)
    |> Enum.max()
  end
end
