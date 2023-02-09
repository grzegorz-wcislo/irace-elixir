defmodule Gallium.Autocorrelation do
  import Nx.Defn

  defn bin(t) do
    {n, _} = Nx.shape(t)
    n * n / 2 / autocorrelation2(1 - 2 * t)
  end

  defn autocorrelation(t) do
    l = lower(t)
    u = upper(t)

    Nx.multiply(l, u)
    |> Nx.sum(axes: [1])
    |> Nx.power(2)
    |> Nx.sum()
  end

  defn autocorrelation2(t) do
    l = lower2(t)
    u = upper2(t)

    Nx.multiply(l, u)
    |> Nx.sum(axes: [2])
    |> Nx.power(2)
    |> Nx.sum(axes: [1])
  end

  defn lower(t) do
    {n} = Nx.shape(t)

    Nx.slice(t, [0], [n - 1])
  end

  defn lower2(t) do
    {m, n} = Nx.shape(t)

    Nx.slice(t, [0, 0], [m, n - 1])
    |> Nx.reshape({m, 1, n - 1})
  end

  defn upper(t) do
    {n} = Nx.shape(t)

    Nx.take(
      Nx.pad(t, 0, [{0, 1, 0}]),
      Nx.select(
        triangle(n),
        Nx.iota({n + 1, n + 1})
        |> Nx.add(n - 1)
        |> Nx.reverse(axes: [0])
        |> Nx.remainder(n)
        |> Nx.slice([0, 0], [n - 1, n - 1]),
        n
      )
    )
  end

  defn upper2(t) do
    {m, n} = Nx.shape(t)

    Nx.gather(
      Nx.pad(t, 0, [{0, 0, 0}, {0, 1, 0}]),
      Nx.concatenate(
        [
          Nx.iota({m, n - 1, n - 1, 1}, axis: 0),
          Nx.select(
            triangle(n),
            Nx.iota({n + 1, n + 1})
            |> Nx.add(n - 1)
            |> Nx.reverse(axes: [0])
            |> Nx.remainder(n)
            |> Nx.slice([0, 0], [n - 1, n - 1]),
            n
          )
          |> Nx.reshape({1, n - 1, n - 1, 1})
          |> Nx.broadcast({m, n - 1, n - 1, 1})
        ],
        axis: 3
      )
    )
  end

  defn triangle(n) do
    Nx.greater_equal(
      Nx.iota({n - 1, 1}, axis: 0),
      Nx.iota({1, n - 1}, axis: 1)
    )
  end
end
