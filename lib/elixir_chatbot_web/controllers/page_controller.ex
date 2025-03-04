defmodule ElixirChatbotWeb.PageController do
  use ElixirChatbotWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def foo(conn, _params) do
    json(conn, %{message: "Hello, world!"})
  end
end
