defmodule Debouncex.MixProject do
  use Mix.Project

  def project do
    [
      app: :debouncex,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A process debouncer for Elixir",
      package: package(),
      name: "Debouncex",
      source_url: "https://github.com/phanhuyanh/debounce",
      docs: [
        main: "Debouncex"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "debouncex",
      licenses: ["MIT"],
      files: ~w(lib .formatter.exs mix.exs README*),
      links: %{"GitHub" => "https://github.com/phanhuyanh/debounce"}
    ]
  end
end
