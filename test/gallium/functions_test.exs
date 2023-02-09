defmodule Gallium.FunctionsTest do
  use ExUnit.Case

  alias Gallium.Functions, as: F

  describe "&onemax/1" do
    test "examples" do
      genomes =
        Nx.tensor([
          [1, 1, 1, 1, 1],
          [1, 0, 1, 0, 1],
          [0, 1, 1, 0, 0],
          [0, 0, 0, 0, 0]
        ])

      assert F.onemax(genomes) == Nx.tensor([5, 3, 2, 0])
    end
  end

  describe "&leading_zeroes/1" do
    test "examples" do
      genomes =
        Nx.tensor([
          [1, 1, 1, 1, 1],
          [0, 0, 1, 1, 0],
          [1, 0, 1, 0, 1],
          [0, 1, 1, 0, 0],
          [0, 0, 1, 1, 1],
          [0, 0, 0, 0, 0]
        ])

      assert F.leading_zeroes(genomes) == Nx.tensor([0, 2, 0, 1, 2, 5])
    end
  end
end
