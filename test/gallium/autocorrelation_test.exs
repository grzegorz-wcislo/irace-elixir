defmodule Gallium.AutocorrelationTest do
  use ExUnit.Case

  describe "&lower/1" do
    expected = Nx.tensor([2, 1, 3])

    assert Gallium.Autocorrelation.lower(Nx.tensor([2, 1, 3, 7])) == expected
  end

  describe "&upper/1" do
    expected =
      Nx.tensor([
        [7, 0, 0],
        [3, 7, 0],
        [1, 3, 7]
      ])

    assert Gallium.Autocorrelation.upper(Nx.tensor([2, 1, 3, 7])) == expected
  end

  describe "&autocorrelation/1" do
    expected = Nx.tensor(1041)

    assert Gallium.Autocorrelation.autocorrelation(Nx.tensor([2, 1, 3, 7])) == expected
  end

  describe "&lower2/1" do
    expected =
      Nx.tensor([
        [[2, 1, 3]],
        [[1, 3, 2]]
      ])

    actual = Gallium.Autocorrelation.lower2(Nx.tensor([[2, 1, 3, 7], [1, 3, 2, 8]]))

    assert actual == expected
  end

  describe "&upper2/1" do
    expected =
      Nx.tensor([
        [
          [7, 0, 0],
          [3, 7, 0],
          [1, 3, 7]
        ],
        [
          [8, 0, 0],
          [2, 8, 0],
          [3, 2, 8]
        ]
      ])

    actual = Gallium.Autocorrelation.upper2(Nx.tensor([[2, 1, 3, 7], [1, 3, 2, 8]]))

    assert actual == expected
  end

  describe "&autocorrelation2/1" do
    expected = Nx.tensor([1041, 1365])

    actual = Gallium.Autocorrelation.autocorrelation2(Nx.tensor([[2, 1, 3, 7], [1, 3, 2, 8]]))
    assert actual == expected
  end
end
