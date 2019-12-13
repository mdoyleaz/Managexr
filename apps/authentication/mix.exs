defmodule Authentication.MixProject do
  use Mix.Project

  def project do
    [
      app: :authentication,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :guardian],
      mod: {Authentication.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:guardian, "~> 2.0"},
      {:argon2_elixir, "~> 2.1"}
    ]
  end
end
