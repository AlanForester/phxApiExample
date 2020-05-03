defmodule Api.Repo.Domains do
  @moduledoc """
  The Domains repo context. Produce redis connections from pool
  """

  @type links() :: [String.Chars.t()]

  alias Api.Redix

  @doc """
  Fetch domains from repo
  """
  @spec fetch_hosts(from :: integer(), to :: integer()) :: links()
  def fetch_hosts(from, to) do
    {:ok, resp} = Redix.command(["zrangebyscore", "domains", from, to])
    if resp != nil, do: resp, else: []
  end

  @doc """
  Save domains to repo from links
  """
  @spec save_hosts(links()) :: boolean()
  def save_hosts(links) do
    hosts = get_insert_pipeline(links)
    {:ok, resp} = Redix.pipeline(hosts)
    if resp != nil, do: true, else: false
  end

  defp get_insert_pipeline(links) do
    links
    |> get_hosts_from_links
    |> uniq_hosts_list
    |> prepare_insert_list
  end

  defp get_hosts_from_links(links) do
    links
    |> Enum.map(fn (link) -> uri = URI.parse(link); uri.host || (if uri.path =~ ".", do: uri.path)end)
  end

  defp uniq_hosts_list(list) do
    Enum.uniq(list)
  end

  defp prepare_insert_list(list) do
    list
    |> Enum.map(fn (link) -> ["zadd", "domains", DateTime.to_unix(DateTime.utc_now(), :millisecond), link] end)
  end

end