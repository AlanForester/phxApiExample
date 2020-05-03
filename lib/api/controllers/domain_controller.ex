defmodule Api.DomainController do
  @moduledoc """
  Controller provides endpoints for domains
  """

  use Api, :controller
  alias Api.Repo.Domains

  @doc """
  Get domains
  """
  def visited_domains(conn, params) do
    if params["from"] == nil || params["to"] == nil do
      conn
      |> put_status(:bad_request)
      |> render("error.json", error: "The GET params 'from' and 'to' is required.")
    end

    from_ts = Integer.parse(params["from"])
    to_ts = Integer.parse(params["to"])
    if from_ts == :error || to_ts == :error do
      conn
      |> put_status(:bad_request)
      |> render("error.json", error: "The GET params 'from' and 'to' should be integer.")
    end
    {from_ts, _} = from_ts
    {to_ts, _} = to_ts

    if to_ts == 0 do
      conn
      |> put_status(:bad_request)
      |> render("error.json", error: "The GET param 'to' should be more than 0.")
    end

    domains = Domains.fetch_hosts(from_ts, to_ts)

    render(conn, "index.json", domains: domains)
  end

  @doc """
  Creates domains from json body
  """
  def visited_links(conn, _params) do

    if conn.body_params == nil || conn.body_params["links"] == nil do
      conn
      |> put_status(:bad_request)
      |> render("error.json", error: "The json param links is required.")
    end

    if length(conn.body_params["links"]) == 0 do
      conn
      |> put_status(:bad_request)
      |> render("error.json", error: "The count of links should be more than 0.")
    end

    if Domains.save_hosts(conn.body_params["links"]) do
      conn
      |> put_status(:created)
      |> render("create.json")
    end
  end
end
