defmodule Debouncex do
  @moduledoc ~S"""
  A process debouncex for Elixir.

  # What is debounce?
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
  """
  use GenServer

  @type arg :: {
          function,
          keyword,
          timeout :: Millisecond
        }

  @type name :: atom()

  @type server :: pid() | name()

  # Functions
  @doc """
  Start Debounce process linked to current process.

  Delay call function until after timeout millisecond have elapsed after last time function call.

  ## Options
    - `:name` : used name for registration. Like in [GenServer.start_link/3](https://hexdocs.pm/elixir/GenServer.html#start_link/3)
  """

  @spec start_link(init_arg :: arg(), opts :: keyword()) :: {:ok, pid}
  def start_link(init_arg, opts \\ []) do
    GenServer.start_link(__MODULE__, init_arg, opts)
  end

  @doc """
  Call function with delay timeout.
  """

  @spec call(server :: server()) :: :ok

  def call(server) do
    GenServer.cast(server, :call)
  end

  @doc """
  Immediately invokes the function.
  """
  @spec flush(server :: server()) :: :ok
  def flush(server) do
    GenServer.cast(server, :flush)
  end

  @doc """
  Change timeout delay call function.
  """
  @spec change_timeout(server :: server(), timeout: Millisecond) :: :ok
  def change_timeout(server, timeout) do
    GenServer.call(server, {:timeout, timeout})
  end

  @doc """
  Cancel current debounce.
  """
  @spec cancel(server :: server()) :: :ok
  def cancel(server) do
    GenServer.cast(server, :cancel)
  end

  @doc """
  Stop current process Debounce
  """
  @spec stop(server :: server()) :: :ok
  def stop(server) do
    GenServer.stop(server, :shutdown)
  end

  # Callbacks
  def init(opts) do
    {:ok, %{info: opts, pid: nil}}
  end

  def handle_cast(:call, state) do
    %{pid: pid, info: info} = state

    if pid && is_pid(pid) do
      Process.exit(pid, :kill)
    end

    pid = schedule(info)

    {:noreply, %{info: info, pid: pid}}
  end

  def handle_cast(:reset, state) do
    {:noreply, %{info: state.info, pid: nil}}
  end

  def handle_cast(:flush, state) do
    %{info: info, pid: pid} = state

    if pid && is_pid(pid) do
      Process.exit(pid, :kill)
    end

    {fun, args, _time} = info

    if is_function(fun) do
      fun.(args)
    end

    {:noreply, %{info: info, pid: nil}}
  end

  def handle_cast(:cancel, state) do
    %{info: info, pid: pid} = state

    if pid && is_pid(pid) do
      Process.exit(pid, :kill)
    end

    {:noreply, %{info: info, pid: nil}}
  end

  defp schedule({fun, args, timeout}) do
    pid = self()

    spawn(fn ->
      :timer.sleep(timeout)

      if is_function(fun) do
        fun.(args)
      end

      GenServer.cast(pid, :reset)
    end)
  end
end
