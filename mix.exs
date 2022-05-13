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
      source_url: "https://github.com/phanhuyanh/debouncex",
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      name: "debouncex",
      licenses: ["MIT"],
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      links: %{"GitHub" => "https://github.com/phanhuyanh/debounce"}
    ]
  end
end
