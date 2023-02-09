defmodule Gallium.Options do
  defstruct [
    :max_experiments,
    :dims,
    :instance,
    :population_size,
    :crossover_points,
    :crossover_alpha,
    :crossover_eta,
    :mutation_sigma,
    :migration_size,
    :emigration_selection,
    :immigration_selection,
    :interval,
    :topology,
    limit: "all",
    selection: "tournament",
    crossover: "uniform",
    mutation: "shift_gaussian",
    mutation_probability: 0,
    populations: 1
  ]
end
