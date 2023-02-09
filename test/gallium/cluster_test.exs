defmodule Gallium.ClusterTest do
  use ExUnit.Case

  describe "&hostnames/1" do
    test "1 hostname" do
      assert Gallium.Cluster.hostnames("p0609") == ["p0609"]
    end

    test "2 hostnames" do
      assert Gallium.Cluster.hostnames("p[0606,0610]") == ["p0606", "p0610"]
    end

    test "multiple hostnames" do
      assert Gallium.Cluster.hostnames("p[2283,0606,0610]") == ["p2283", "p0606", "p0610"]
    end

    test "range hostnames" do
      assert Gallium.Cluster.hostnames("p[1356-1358,1368]") == [
               "p1356",
               "p1357",
               "p1358",
               "p1368"
             ]
    end
  end

  describe "&nodes/1" do
    test "1 hostname" do
      assert Gallium.Cluster.nodes(["p123"]) == [:node1@p123, :node2@p123]
    end

    test "2 hostname" do
      assert Gallium.Cluster.nodes(["p123", "p321"]) == [
               :node1@p123,
               :node2@p123,
               :node1@p321,
               :node2@p321
             ]
    end
  end
end
