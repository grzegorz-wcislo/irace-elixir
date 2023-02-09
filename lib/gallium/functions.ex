defmodule Gallium.Functions do
  @moduledoc false

  import Nx.Defn

  @tau 2 * :math.pi()

  defn rastrigin(genomes) do
    {_, genome_length} = Nx.shape(genomes)

    (10 + Nx.power(genomes, 2) - 10 * Nx.cos(genomes * @tau))
    |> Nx.sum(axes: [1])
    |> Nx.divide(-genome_length)
  end

  defn sphere(genomes) do
    sums =
      Nx.power(genomes, 2)
      |> Nx.sum(axes: [1])

    -sums
  end

  defn rosenbrock(genomes) do
    {_, genome_length} = Nx.shape(genomes)
    x_i_plus_1 = Nx.transpose(genomes)[1..(genome_length - 1)] |> Nx.transpose()
    x_i = Nx.transpose(genomes)[0..(genome_length - 2)] |> Nx.transpose()
    x_i_2 = Nx.power(x_i, 2)

    left = 100 * Nx.power(x_i_plus_1 - x_i_2, 2)
    right = Nx.power(1 - x_i, 2)

    Nx.sum(left + right, axes: [1])
    |> Nx.divide(1 - genome_length)
  end

  defn styblinski_tang(genomes) do
    {_, genome_length} = Nx.shape(genomes)

    (Nx.power(genomes, 4) - 16 * Nx.power(genomes, 2) + 5 * genomes)
    |> Nx.sum(axes: [1])
    |> Nx.divide(-2 * genome_length)
    |> Nx.add(-40)
  end

  defn schwefel(genomes) do
    {_, genome_length} = Nx.shape(genomes)

    Nx.multiply(
      genomes,
      genomes |> Nx.abs() |> Nx.sqrt() |> Nx.sin()
    )
    |> Nx.sum(axes: [1])
    |> Nx.divide(genome_length)
    |> Nx.add(-418.9829)
  end

  defn step2(genomes) do
    genomes
    |> Nx.add(0.5)
    |> Nx.floor()
    |> Nx.power(2)
    |> Nx.sum(axes: [1])
    |> Nx.multiply(-1)
  end

  defn exponential(genomes) do
    genomes
    |> Nx.power(2)
    |> Nx.sum(axes: [1])
    |> Nx.multiply(-0.5)
    |> Nx.exp()
  end

  defn onemax(genomes) do
    Nx.sum(genomes, axes: [1])
  end

  defn leading_zeroes(genomes) do
    leading_or_zero = Nx.argmax(genomes, axis: 1)
    first = Nx.take(genomes, 0, axis: 1)

    {_, len} = Nx.shape(genomes)

    leading_or_zero + Nx.equal(leading_or_zero, 0) * (1 - first) * len
  end
end
