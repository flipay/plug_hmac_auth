defmodule PlugHmacAuth.MixProject do
  use Mix.Project

  @version "0.1.0"
  @name "PlugHmacAuth"
  @description "A Plug adapter for HMAC authentication"

  def project do
    [
      app: :plug_hmac_auth,
      version: @version,
      elixir: "~> 1.10",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: @name,
      description: @description,
      docs: [
        extras: [
          "README.md"
        ],
        main: "PlugHmacAuth",
        source_ref: "v#{@version}",
        source_url: "https://github.com/flipay/plug_hmac_auth"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.10"},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22.0", only: :docs}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Neo Ho"],
      organization: ["Flipay"],
      links: %{"GitHub" => "https://github.com/flipay/plug_hmac_auth"}
    }
  end
end
