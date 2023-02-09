defmodule Gallium.Mutation do
  @moduledoc false

  alias MeowNx.Ops

  def from_opts(
        %{
          mutation: "replace_uniform",
          mutation_probability: mutation_probability
        },
        min,
        max
      ) do
    Ops.mutation_replace_uniform(mutation_probability, min, max)
  end

  def from_opts(
        %{
          mutation: "shift_gaussian",
          mutation_probability: mutation_probability,
          mutation_sigma: sigma
        },
        _,
        _
      ) do
    Ops.mutation_shift_gaussian(mutation_probability, sigma: sigma)
  end

  def from_opts(
        %{
          mutation: "bit_flip",
          mutation_probability: mutation_probability
        },
        _,
        _
      ) do
    Ops.mutation_bit_flip(mutation_probability)
  end
end
