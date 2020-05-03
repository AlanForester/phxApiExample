defmodule Api.DomainView do
  use Api, :view
  alias Api.DomainView

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("create.json", _) do
    %{status: "ok"}
  end

  def render("index.json", %{domains: domains}) do
    %{domains: render_many(domains, DomainView, "domain.json"), status: "ok"}
  end

  def render("domain.json", %{domain: domain}) do
    domain
  end
end
