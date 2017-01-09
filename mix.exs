defmodule MatrixApplicationService.Mixfile do
  use Mix.Project

  def project do
    [app: :matrix_application_service,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
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
    d = [{:httpoison, "~> 0.10"},
         {:plug, "> 0.0.0"},
         {:inch_ex, "> 0.0.0", only: :docs},
         {:ex_doc, "~> 0.7", only: :dev}]
         #{:earmark, "~> 0.1", only: :docs}]

    if Mix.env == :test do
      [{:coverex, "~> 1.4.8", only: :test}, {:poison, "~> 2.1.0", override: true} | d]
    else
      [{:poison, "~> 2.1.0"} | d]
    end
  end
end
