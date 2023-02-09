defmodule GalliumTest do
  use ExUnit.Case

  describe "&run/1" do
    test "example rastrigin" do
      result =
        Gallium.run(
          "1 2 3 /i/rastrigin.txt --max-experiments 100 --dims 50 --limit pop --population-size 10 --selection natural --crossover blend_alpha --crossover-alpha 0.5 --mutation replace_uniform --mutation-probability 0.003 --populations 2 --interval 10 --topology ring --migration-size 1 --emigration-selection natural --immigration-selection tournament"
        )

      assert result < 0
      assert result > -1000
    end

    test "example onemax" do
      result =
        Gallium.run(
          "1 2 3 /i/onemax.txt --max-experiments 100 --dims 50 --limit pop --population-size 10 --selection natural --crossover multi_point --crossover-points 2 --mutation bit_flip --mutation-probability 0.003 --populations 2 --interval 10 --topology ring --migration-size 1 --emigration-selection natural --immigration-selection tournament"
        )

      assert result > 25
      assert result <= 50
    end
  end
end
