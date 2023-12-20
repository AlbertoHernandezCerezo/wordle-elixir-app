# Hackday 2023

### Building a simple Wordle Game with Elixir & Phoenix Framework

#### 1. Create Elixir application

We will create a simple `Elixir` application for our project. We will use the default options for now, even though we might not need to make use of certain tools, such as the database:

```
mix phx.new --live wordle_elixir_app
```

Once the application is created we need to set up the database:

```
mix ecto.create
```

If you experience any problems with the database credentials, go to `config/dev.exs` and adjust the configuration parameters in there.

In my case I was experiencing this error:

```
10:50:32.395 [error] Postgrex.Protocol (#PID<0.211.0>) failed to connect: ** (Postgrex.Error) FATAL 28000 (invalid_authorization_specification) role "postgres" does not exist

10:50:32.401 [error] Postgrex.Protocol (#PID<0.218.0>) failed to connect: ** (Postgrex.Error) FATAL 28000 (invalid_authorization_specification) role "postgres" does not exist
** (Mix) The database for WordleElixirApp.Repo couldn't be created: killed
```

Which was solved by removing the authentication credentials for my development environment:

```
# config/dev.exs
...
# Configure your database
config :wordle_elixir_app, WordleElixirApp.Repo,
  hostname: "localhost",
  database: "wordle_elixir_app_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
...
```

Once changes were made to the config file, I ran the command again and everything worked fine:

```
> mix ecto.create                                                        

Compiling 15 files (.ex)
Generated wordle_elixir_app app
The database for WordleElixirApp.Repo has been created
```

And now I can run the `Phoenix` application with the command:

```
mix phx.server
```

The application should be available under http://localhost:4000/

#### 2. Writing some basic game logic

Before working with `Phoenix`, we can write some `Elixir` code to warm up and get familiar with the language. Since the game logic is agnostic of the framework specification we can start writing it, and writing some tests on the side.

