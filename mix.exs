defmodule MakeupFormatter.MixProject do
  use Mix.Project

  def project do
    [
      app: :makeup_formatter,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:makeup, "~> 1.1"},
      {:makeup_elixir, "~> 0.15.2", only: [:dev, :test]}
    ]
  end
end
