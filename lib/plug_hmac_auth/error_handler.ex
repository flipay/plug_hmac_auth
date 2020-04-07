if Code.ensure_loaded?(Plug) do
  defmodule PlugHmacAuth.ErrorHandler do
    @moduledoc """
    PlugHmacAuth emit error types:
    :invalid_key
    :invalid_signature
    """

    @doc "Define the method of how to deal with unauthentication"
    @callback auth_error(conn :: Plug.Conn.t(), type :: atom()) :: Plug.Conn.t()
  end
end
