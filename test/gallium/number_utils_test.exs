defmodule Gallium.NumberUtilsTest do
  use ExUnit.Case

  alias Gallium.NumberUtils, as: NU

  describe "&nx_gte/2" do
    test "numbers greater" do
      assert NU.nx_gte(10, 2)
      assert NU.nx_gte(10, :neg_infinity)
    end

    test "numbers equal" do
      assert NU.nx_gte(1.0, 1.0)
    end

    test "numbers less" do
      refute NU.nx_gte(1.0, 2)
      refute NU.nx_gte(1.0, :infinity)
    end

    test "infinity greater" do
      assert NU.nx_gte(:infinity, 100)
      assert NU.nx_gte(:infinity, :neg_infinity)
    end

    test "infinity equal" do
      assert NU.nx_gte(:infinity, :infinity)
    end

    test "neg_infinity equal" do
      assert NU.nx_gte(:neg_infinity, :neg_infinity)
    end

    test "neg_infinity less" do
      refute NU.nx_gte(:neg_infinity, 2)
    end
  end

  describe "&negate/1" do
    test "numbers" do
      assert NU.negate(0) == 0
      assert NU.negate(5) == -5
      assert NU.negate(-2.0) == 2.0
    end

    test "infinity" do
      assert NU.negate(:infinity) == :neg_infinity
      assert NU.negate(:neg_infinity) == :infinity
    end
  end

  describe "&to_r/1" do
    test "numbers" do
      assert NU.to_r(0) == "0"
      assert NU.to_r(5) == "5"
      assert NU.to_r(-2.0) == "-2.0"
    end

    test "infinity" do
      assert NU.to_r(:infinity) == "Inf"
      assert NU.to_r(:neg_infinity) == "-Inf"
    end
  end
end
