defmodule BDF.MixProject do
  use Mix.Project

  def project do
    [
      app: :bdf,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: :dev, runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ~w"README.md",
      groups_for_docs: [
        Guards: & &1[:guard]
      ]
    ]
  end
end
