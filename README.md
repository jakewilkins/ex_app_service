# MatrixApplicationService

A Plug for writing Matrix.org Application services in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `matrix_application_service` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:matrix_application_service, "~> 0.1.0"}]
    end
    ```

  2. Ensure `matrix_application_service` is started before your application:

    ```elixir
    def application do
      [applications: [:matrix_application_service]]
    end
    ```

## Usage

To run just this plug, you can just add this to your supervision tree:

```elixir
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    #port = System.get_env("PORT") |> String.to_integer || 8080
    port = 8080

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Twilapze.Worker.start_link(arg1, arg2, arg3)
      # worker(Twilapze.Worker, [arg1, arg2, arg3]),
      Plug.Adapters.Cowboy.child_spec(:http, MatrixApplicationService.Router,
        Twilapse.matrix_app_service_callbacks, [port: port])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Twilapse.Supervisor]
    Supervisor.start_link(children, opts)
  end
```

Or if you're running this within a larger Plug app, you can mount this in your
Router:

#TODO


#License

```
        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
                    Version 2, December 2004 

 Copyright (C) 2017 Jake Wilkins <jake@tolerable.tech> 

 Everyone is permitted to copy and distribute verbatim or modified 
 copies of this license document, and changing it is allowed as long 
 as the name is changed. 

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 

  0. You just DO WHAT THE FUCK YOU WANT TO.
```

