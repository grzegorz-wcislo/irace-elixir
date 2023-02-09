defmodule Gallium do
  @moduledoc false

  alias Gallium.{Crossover, Generations, Migrations, Mutation}
  alias MeowNx.Ops

  @instances %{
    "rastrigin" => {:real, &Gallium.Functions.rastrigin/1, -5.12, 5.12},
    "sphere" => {:real, &Gallium.Functions.sphere/1, -500.0, 500.0},
    "schwefel" => {:real, &Gallium.Functions.schwefel/1, -500.0, 500.0},
    "rosenbrock" => {:real, &Gallium.Functions.rosenbrock/1, -5.0, 10.0},
    "styblinski_tang" => {:real, &Gallium.Functions.styblinski_tang/1, -5.0, 5.0},
    "step2" => {:real, &Gallium.Functions.step2/1, -100.0, 100.0},
    "exponential" => {:real, &Gallium.Functions.exponential/1, -1.0, 1.0},
    "onemax" => {:binary, &Gallium.Functions.onemax/1, 0, 1},
    "leading_zeroes" => {:binary, &Gallium.Functions.leading_zeroes/1, 0, 1},
    "labs" => {:binary, &Gallium.Autocorrelation.bin/1, 0, 1}
  }

  @selection %{
    "tournament" => &Ops.selection_roulette/1,
    "natural" => &Ops.selection_natural/1,
    "roulette" => &Ops.selection_roulette/1,
    "sus" => &Ops.selection_stochastic_universal_sampling/1
  }

  def model(
        %Gallium.Options{
          instance: instance,
          dims: dims,
          population_size: population_size,
          selection: selection,
          populations: populations
        } = opts
      ) do
    {representation, objective, min, max} = Map.fetch!(@instances, instance)
    selection_fun = Map.fetch!(@selection, selection)

    init =
      case representation do
        :real -> Ops.init_real_random_uniform(population_size, dims, min, max)
        :binary -> Ops.init_binary_random_uniform(population_size, dims)
      end

    clamp =
      case representation do
        :real -> [Gallium.Ops.clamp(min, max)]
        :binary -> []
      end

    Meow.objective(objective)
    |> Meow.add_pipeline(
      init,
      Meow.pipeline(
        Enum.concat([
          [
            selection_fun.(population_size),
            Crossover.from_opts(opts),
            Mutation.from_opts(opts, min, max)
          ],
          clamp,
          Migrations.from_opts(opts),
          [
            Ops.log_best_individual(),
            Generations.from_opts(opts)
          ]
        ])
      ),
      duplicate: populations
    )
  end

  def run(input) do
    # ensure even population size
    options = Gallium.Parser.get_options(input) |> Map.update!(:population_size, &(&1 * 2))

    report = Meow.run(model(options), nodes: [node() | :erlang.nodes()])

    report.population_reports
    |> Enum.map(fn result -> result.population.log.best_individual.fitness end)
    |> Enum.max(&Gallium.NumberUtils.nx_gte/2)
  end
end
