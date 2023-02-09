defmodule Gallium.MixProject do
  use Mix.Project

  def project do
    [
      app: :gallium,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:meow, "~> 0.1.0-dev", git: "git@github.com:jonatanklosko/meow.git"},
      {:exla, "~> 0.1.0-dev", github: "elixir-nx/nx", sparse: "exla"},
      {:nx, "~> 0.1.0-dev", github: "elixir-nx/nx", sparse: "nx", override: true},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end
end
