defmodule Gallium.Cluster do
  @regex_one ~r/^p[[:digit:]]+$/
  @regex_multiple ~r/^p\[(?<ids>([[:digit:]-],?)+)\]/
  @nodes_per_hostname 2

  def slurm_nodelist() do
    System.get_env("SLURM_NODELIST")
  end

  def hostnames(nodelist \\ slurm_nodelist()) do
    cond do
      String.match?(nodelist, @regex_one) ->
        [nodelist]

      String.match?(nodelist, @regex_multiple) ->
        Regex.named_captures(@regex_multiple, nodelist)
        |> Map.get("ids")
        |> String.split(",")
        |> Enum.flat_map(fn id ->
          case Integer.parse(id) do
            {_, ""} ->
              [id]

            {id1, <<"-", id2::binary>>} ->
              id1..String.to_integer(id2) |> Enum.map(&Integer.to_string/1)
          end
        end)
        |> Enum.map(&("p" <> &1))

      true ->
        nil
    end
  end

  def nodes(hostnames \\ hostnames()) do
    hostnames
    |> Enum.flat_map(fn hostname ->
      1..@nodes_per_hostname
      |> Enum.map(fn node ->
        :"node#{node}@#{hostname}"
      end)
    end)
  end
end
