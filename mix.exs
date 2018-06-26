defmodule Exsolr.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exsolr,
      version: "0.0.2",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description,
      package: package,
      deps: deps,
    ]
  end

  defp description do
    """
    Thin Wrapper around Solr api.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Daniel Carneiro"],
      licenses: ["MIT License (MIT)"],
      links: %{"GitHub" => "https://github.com/OIT-ADS-Web/exsolr",
              "Docs" => "http://hexdocs.pm/exsolr/"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:httpoison, :logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:dialyxir, "~> 0.3", only: :dev},
    ]
  end
end
