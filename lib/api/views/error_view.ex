defmodule Api.ErrorView do
  use Api, :view

  def render("400.json", _assigns) do
    %{error: "Bad request"}
  end

  def render("404.json", _assigns) do
    %{error: "Endpoint not found"}
  end

  def render("500.json", _assigns) do
    %{error: "Internal server error"}
  end

end
