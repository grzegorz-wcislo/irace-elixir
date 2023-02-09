defmodule Gallium.Migrations do
  @moduledoc false

  @migration_topologies %{
    "ring" => &Meow.Topology.ring/2,
    "mesh2d" => &Meow.Topology.mesh2d/2,
    "mesh3d" => &Meow.Topology.mesh3d/2,
    "fully_connected" => &Meow.Topology.fully_connected/2,
    "star" => &Meow.Topology.star/2
  }

  @selection %{
    "tournament" => &MeowNx.Ops.selection_roulette/1,
    "natural" => &MeowNx.Ops.selection_natural/1,
    "roulette" => &MeowNx.Ops.selection_roulette/1,
    "sus" => &MeowNx.Ops.selection_stochastic_universal_sampling/1
  }

  def from_opts(%{populations: 1}), do: []

  def from_opts(%{
        topology: topology,
        emigration_selection: emigration_selection,
        immigration_selection: immigration_selection,
        migration_size: migration_size,
        interval: interval
      }) do
    topology = Map.fetch!(@migration_topologies, topology)
    emigration_selection_fun = Map.fetch!(@selection, emigration_selection)
    immigration_selection_fun = Map.fetch!(@selection, immigration_selection)

    [
      Meow.Ops.emigrate(emigration_selection_fun.(migration_size), topology, interval: interval),
      Meow.Ops.immigrate(immigration_selection_fun, interval: interval, blocking: false)
    ]
  end
end
