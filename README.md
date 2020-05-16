# HMAC Authentication Plug

[Plug](https://hex.pm/packages/plug) support for [HMAC](https://en.wikipedia.org/wiki/HMAC) authentication. This is used for authentication between server sides.

![plug_hmac_auth](https://user-images.githubusercontent.com/13026209/82128415-46d6ab00-97e5-11ea-8c92-89f88d726b9a.png)

## Installation

This package can be installed by adding `plug_hmac_auth` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_hmac_auth, "~> 0.1.0"}
  ]
end
```

## Usage

Here we demonstrate the usage by [this example](https://github.com/flipay/plug_hmac_auth_example). Replace the `PlugHmacAuthExample` by the name of your own web site.

### PlugHmacAuthExampleWeb.Endpoint

We use some raw data as [payload](https://github.com/flipay/plug_hmac_auth/blob/a978ac5051686ce1a9539a315a062009fd2045ae/lib/plug_hmac_auth.ex#L76) to verify the request from client.

For those `GET` requests, we use `query string` as payload. 

For other requests, we use `raw body` as payload. But the raw body of request can only be read once. That means we can't read the raw body after the `Plug.Parsers`. Instead of the original body reader provided by `Plug.Parsers`, we need to use a custom body reader to cache the `raw body`.

```elixir
plug Plug.Parsers,
  parsers: [:urlencoded, :multipart, :json],
  pass: ["*/*"],
  json_decoder: Phoenix.json_library(),
  body_reader: {PlugHmacAuth.BodyReader, :read_body, []}
```

### PlugHmacAuthExampleWeb.Router

In the router module of your web site, define a new pipeline to enable the plug of HMAC authentication:

```elixir
pipeline :plug_hmac_auth do
  plug(PlugHmacAuth,
    key_access_id: "x-access-id",
    key_signature: "x-access-signature",
    hmac_hash_algo: :sha512,
    secret_handler: PlugHmacAuthExample.Handlers.SecretHandler,
    error_handler: PlugHmacAuthExampleWeb.ErrorHandler
  )
end
```

Module `PlugHmacAuth` needs these options:

- `key_access_id`: The key of `access_id` in the HTTP request header.
- `key_signature`: The key of `signature` in the HTTP request header.
- `hmac_hash_algo`: The algorithm of HMAC.
- `secret_handler`: Secret handler is the module to get the `secret` by given `access_id`.
- `error_handler`: Error handler is the module to handle the unauthorized request.

### HMAC hash algorithm

[Here](https://github.com/flipay/plug_hmac_auth/blob/a978ac5051686ce1a9539a315a062009fd2045ae/lib/plug_hmac_auth.ex#L12) lists the algorithms current supported.

### Secret Handler

We need to implement the callback function of `get_secret_key/1` to let authenticator know how to get the secret key by given access id.

### Error Handler

We need to implement the callback function of `auth_error/2` to let the authenticator know how to handle the unauthorized request.

## Documentation

See [HexDocs](https://hexdocs.pm/plug_hmac_auth).

## Reference

- [Demo API Server Using This HMAC Authentication Plug](https://github.com/flipay/plug_hmac_auth_example)
- [HMAC Authentication: Better protection for your API](https://dev.to/pim/hmac-authentication-better-protection-for-your-api-4e0)