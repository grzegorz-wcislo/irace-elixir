defmodule Gallium.NumberUtils do
  def nx_gte(a, b) when is_number(a) and is_number(b), do: a >= b
  def nx_gte(:infinity, _b), do: true
  def nx_gte(_a, :infinity), do: false
  def nx_gte(_a, :neg_infinity), do: true
  def nx_gte(:neg_infinity, _b), do: false

  def negate(a) when is_number(a), do: -a
  def negate(:infinity), do: :neg_infinity
  def negate(:neg_infinity), do: :infinity

  def to_r(a) when is_number(a), do: "#{a}"
  def to_r(:infinity), do: "Inf"
  def to_r(:neg_infinity), do: "-Inf"
end
