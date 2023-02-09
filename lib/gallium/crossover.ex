defmodule Gallium.Crossover do
  @moduledoc false

  alias MeowNx.Ops

  def from_opts(%{crossover: "uniform"}), do: Ops.crossover_uniform()

  def from_opts(%{crossover: "multi_point", crossover_points: points}) do
    Ops.crossover_multi_point(points)
  end

  def from_opts(%{crossover: "blend_alpha", crossover_alpha: alpha}) do
    Ops.crossover_blend_alpha(alpha)
  end

  def from_opts(%{crossover: "simulated_binary", crossover_eta: eta}) do
    Ops.crossover_simulated_binary(eta)
  end
end
