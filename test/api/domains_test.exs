defmodule Api.DomainsTest do

  use Api.ConnCase

  alias Api.Repo.Domains

  @create_domains [
    "https://ya.ru",
    "https://ya.ru?q=123",
    "funbox.ru",
    "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor",
  ]

  def domain_save(str) do
    Domains.save_hosts([str])
  end

  test "create_domains/1 insert the domain" do
    assert Domains.save_hosts(@create_domains)
  end

  test "fetch_domain/0 returns domain with 'http://' string" do
    host = "#{random_string()}.com"
    link = "http://#{host}"
    domain_save(link)
    domains = Domains.fetch_hosts(0, 3213213232342)
    assert Enum.member?(domains, host)
  end

  test "fetch_domain/1 returns domain without 'http://' string, but with dot" do
    host = "#{random_string()}.com"
    domain_save(host)
    domains = Domains.fetch_hosts(0, 3213213232342)
    assert Enum.member?(domains, host)
  end

  test "fetch_domain/1 returns domain without 'http://' string and without dot" do
    host = "#{random_string()}com"
    domain_save(host)
    domains = Domains.fetch_hosts(0, 3213213232342)
    refute Enum.member?(domains, host)
  end

  test "fetch_domain/1 returns domain with 'http://' string only" do
    host = "http://"
    domain_save(host)
    domains = Domains.fetch_hosts(0, 3213213232342)
    refute refute Enum.member?(domains, host)
  end

  def random_string() do
    :crypto.strong_rand_bytes(5)
    |> Base.url_encode64
    |> binary_part(0, 5)
  end

end
