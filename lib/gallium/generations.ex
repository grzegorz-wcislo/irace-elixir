defmodule Gallium.Generations do
  @moduledoc false

  def from_opts(%{
        max_experiments: max_experiments,
        limit: limit,
        population_size: population_size,
        populations: populations
      }) do
    case limit do
      "all" -> (max_experiments / (population_size * populations)) |> ceil()
      "pop" -> (max_experiments / population_size) |> ceil()
    end
    |> Meow.Ops.max_generations()
  end
end
