# Debouncex
A process debouncer for Elixir

## Docs
[Debouncex](https://hexdocs.pm/debouncex)

## What is Debounce?
Debounce will call function with delay timeout, but if function is called multiple time with delay
  period, the time is reset and delay is counted again. Like debounce in Javascript but for Elixir.

  # Example
  ```elixir
  iex> defmodule Hello do
     def hello do
      :world
    end
  end

  iex> {:ok, pid} = Debouncex.start_link({
    &Hello.hello/0,
    [],
    1000
  })

  iex> Debouncex.call(pid) # Scheduler call after 1s
  iex> :timer.sleep(100)
  iex> Debouncex.call(pid) # Scheduler call after 1s
  iex> :world
   ```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `debouncex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:debouncex, "~> 0.1.0"}
  ]
end
```
