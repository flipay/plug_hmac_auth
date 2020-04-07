defmodule PlugHmacAuth.SecretHandler do
  @doc "Define the method of how to get `secret_key` by `access_key_id`"
  @callback get_secret_key(access_key_id :: String.t()) :: {:ok, String.t()} | {:error, atom()}
end
