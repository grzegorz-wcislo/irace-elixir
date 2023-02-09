defmodule Gallium.ParserTest do
  use ExUnit.Case

  test "parses options" do
    input =
      [
        "36 2 313183014 /code/irace/Instances/sphere.txt",
        "--max-experiments 1000000",
        "--limit pop",
        "--population-size 453",
        "--dims 100",
        "--selection natural",
        "--crossover custom_crossover",
        "--crossover-points 3",
        "--crossover-alpha 0.1",
        "--crossover-eta 4.5",
        "--mutation custom_mutation",
        "--mutation-probability 0.0064",
        "--mutation-sigma 1.5",
        "--topology star",
        "--migration-size 5",
        "--emigration-selection sus",
        "--immigration-selection tournament",
        "--interval 7",
        "--populations 19"
      ]
      |> Enum.join(" ")

    expected = %Gallium.Options{
      instance: "sphere",
      max_experiments: 1_000_000,
      limit: "pop",
      dims: 100,
      population_size: 453,
      selection: "natural",
      crossover: "custom_crossover",
      crossover_points: 3,
      crossover_alpha: 0.1,
      crossover_eta: 4.5,
      mutation: "custom_mutation",
      mutation_probability: 0.0064,
      mutation_sigma: 1.5,
      topology: "star",
      migration_size: 5,
      emigration_selection: "sus",
      immigration_selection: "tournament",
      interval: 7,
      populations: 19
    }

    actual = Gallium.Parser.get_options(input)

    assert expected == actual
  end

  test "sets defaults" do
    input = "36 2 313183014 /code/irace/Instances/sphere.txt"

    expected = %Gallium.Options{
      instance: "sphere",
      max_experiments: nil,
      limit: "all",
      dims: nil,
      population_size: nil,
      selection: "tournament",
      crossover: "uniform",
      crossover_points: nil,
      crossover_alpha: nil,
      crossover_eta: nil,
      mutation: "shift_gaussian",
      mutation_probability: 0,
      mutation_sigma: nil,
      topology: nil,
      migration_size: nil,
      immigration_selection: nil,
      emigration_selection: nil,
      interval: nil,
      populations: 1
    }

    actual = Gallium.Parser.get_options(input)

    assert expected == actual
  end
end
