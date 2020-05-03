defmodule Api.Redix do
  @moduledoc """
  This module creates pool of redis connections and implements basic commands.
  """

  @pool_size 5

  @type command() :: [String.Chars.t()]

  def child_spec(_args) do
    # Specs for the Redix connections.
    children =
      for i <- 0..(@pool_size - 1) do
        Supervisor.child_spec(
          {Redix, name: :"redix_#{i}", host: "redis", port: 6379},
          id: {Redix, i}
        )
      end

    # Spec for the supervisor that will supervise the Redix connections.
    %{
      id: RedixSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

  @doc """
  Issues a command on the Redix pool.
  """
  @spec command(command()) :: {:ok, Redix.Protocol.redis_value()} |
                              {:error, atom() | Redix.Error.t() | Redix.ConnectionError.t()}
  def command(command) do
    Redix.command(:"redix_#{random_index()}", command)
  end

  @doc """
  Issues a pipeline of commands on the Redix pool.
  """
  @spec pipeline([command()]) :: {:ok, [Redix.Protocol.redis_value()]} |
                                 {:error, atom() | Redix.Error.t() | Redix.ConnectionError.t()}
  def pipeline(command) do
    Redix.pipeline(:"redix_#{random_index()}", command)
  end

  @doc """
  Flush all data in redis db.
  """
  @spec flush_all() :: {:ok, [Redix.Protocol.redis_value()]} |
                       {:error, atom() | Redix.Error.t() | Redix.ConnectionError.t()}
  def flush_all() do
    Redix.command(:"redix_#{random_index()}", ["FLUSHALL"])
  end

  defp random_index() do
    rem(System.unique_integer([:positive]), @pool_size)
  end
end