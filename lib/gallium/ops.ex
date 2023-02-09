defmodule Gallium.Ops do
  @moduledoc false

  import Nx.Defn

  def clamp(min, max) do
    %Meow.Op{
      name: "[Nx] Clamp between min and max",
      requires_fitness: false,
      invalidates_fitness: true,
      in_representations: [MeowNx.real_representation()],
      impl: fn population, _ctx ->
        Meow.Population.map_genomes(population, fn genomes ->
          do_clamp(genomes, min, max)
        end)
      end
    }
  end

  defnp do_clamp(genomes, min, max) do
    Nx.clip(genomes, min, max)
  end
end
