defmodule Api.DomainControllerTest do

  use Api.ConnCase

  alias Api.Repo.Domains

  @create_domains_valid %{
    links: [
      "https://ya.ru",
      "https://ya.ru?q=123",
      "funbox.ru",
      "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor",
    ]
  }

  def fixture() do
    rand_domain = "https://#{random_string()}.com"
    Domains.save_hosts([rand_domain])
    rand_domain
  end

  setup do
    {:ok, conn: put_req_header(build_conn(), "accept", "application/json")}
  end

  describe "create domains" do
    test "renders domain when POST data is valid", %{conn: conn} do
      conn_1 = post(conn, Routes.domain_path(conn, :visited_links), @create_domains_valid)
      assert %{"status" => "ok"} = json_response(conn_1, 201)

      conn_2 = get(conn, Routes.domain_path(conn, :visited_domains, %{from: 0, to: 99999999999}))
      assert %{"status" => "ok"} = json_response(conn_2, 200)

    end
  end

  describe "fetch domains" do
    test "lists all domains", %{conn: conn} do
      fixture()
      conn_3 = get(conn, Routes.domain_path(conn, :visited_domains, %{from: 0, to: 99999999999}))
      assert json_response(conn_3, 200)["domains"]
    end
  end

  def random_string() do
    :crypto.strong_rand_bytes(5)
    |> Base.url_encode64
    |> binary_part(0, 5)
  end
end
