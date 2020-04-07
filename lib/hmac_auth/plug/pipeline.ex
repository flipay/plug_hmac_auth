if Code.ensure_loaded?(Plug) do
  defmodule HmacAuth.Plug.Pipeline do
    import Plug.Conn

    defmacro __using__(opts \\ []) do
      alias HmacAuth.Plug
      alias HmacAuth.Plug.Pipeline

      quote do
        use Plug.Builder
        import Pipeline

        plug(:put_modules)

        def init(options) do
          new_opts =
            options
            |> Keyword.merge(unquote(opts))
            |> config()

          unless Keyword.get(new_opts, :otp_app), do: raise_error(:otp_app)

          new_opts
        end

        defp config(opts) do
          case Keyword.get(opts, :otp_app) do
            nil ->
              opts

            otp_app ->
              otp_app
              |> Application.get_env(__MODULE__, [])
              |> Keyword.merge(opts)
          end
        end

        defp config(opts, key, default \\ nil) do
          unquote(opts)
          |> Keyword.merge(opts)
          |> config()
          |> Keyword.get(key)
          |> Guardian.Config.resolve_value()
        end

        defp put_modules(conn, opts) do
          pipeline_opts = [
            key_access_id: config(opts, :key_access_id),
            key_signature: config(opts, :key_signature),
            hmac_hash_algo: config(opts, :hmac_hash_algo, :sha512),
            secret_handler: config(opts, :secret_handler),
            error_handler: config(opts, :error_handler)
          ]

          Pipeline.call(conn, pipeline_opts)
        end
      end
    end
  end
end
